; ººº¹¹º¹º¹º¹º¹¹¹ººº¹º¹º¹º¹ººº¹º¹¹¹º¹º¹¹¹º¹º¹¹¹ºº
; º¹|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|¹º
; ºº| ÜÜÛÛÛÛÛÛÛÛÛ   ÜÜÛÛÛÛÛÛÛÜÜ   ÜÛÛÛÛÛÛÛÛÛÜ |º¹
; º¹| ÛÛÛÛÛÛÛÛÛßß   ÛÛÛÛÛÛÛÛÛßß   ßÛÛÛÛÛÛÛÛÛß |¹¹
; ºº| ÛÛ            ÛÛß               ÛÛÛ     |¹º
; ºº| ÛÛ            ÛÛ                ÛÛÛ     |ºº
; ºº| ÛÛÛÛÛÛÛÛÛÜÜ   ÛÛ                ÛÛÛ     |¹¹
; ¹¹| ßßÛÛÛÛÛÛÛÛÛ   ÛÛ                ÛÛÛ     |¹º
; º¹|          ÛÛ   ÛÛ                ÛÛÛ     |¹¹
; ºº|          ÛÛ   ÛÛÜ               ÛÛÛ     |¹¹
; ¹¹| ÜÜÛÛÛÛÛÛÛÛÛ   ÛÛÛÛÛÛÛÛÛÜÜ       ÛÛÛ     |¹º
; ºº| ÛÛÛÛÛÛÛÛÛßß   ßßÛÛÛÛÛÛÛßß       ßÛß     |ºº
; ¹¹|                                         |¹¹
; º¹|                home of secret reversers®|º¹
; ¹¹|_________________________________________|¹¹
; OsVersionX Application
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@sctzine.com>
; IDE		: RADAssembler v2.2.2.2 <http://masm32.com/board/index.php?board=24.0>
; Taslak	: BlueDeviL // SCT
; Tarih  	: 05.06.2017 - 13.06.2017
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com
TITLE  [SCT]OsVersionX Application	 				  			(OsVersionX.asm)
.486					
.model		flat, stdcall	
option		casemap :none	

include		OsVersionX.Inc

.code
start:
	call	main
	inkey				
	exit
	
main proc
	LOCAL	szVer	:DWORD
	
	invoke	SetConsoleTitle,addr konsolBaslik		
	invoke	ClearScreen								
	print	addr sctGS

	print	"Displaying Version Info From Process Environment Block:",13,10
    ASSUME	FS:Nothing
    mov		edx,fs:[30h]		;PEB.InheritedAddressSpace
    mov 	szVer,edx
    ASSUME  FS:ERROR
    mov     eax,[edx+0A4h]		;eax = Major Sürüm
    push	eax
    push    edx
    print   ustr$(eax),'.'
    pop     edx
    push	edx
    mov     eax,[edx+0A8h]		;eax = Minor Sürüm
    print   ustr$(eax),'.'
    pop 	edx
    mov 	eax,[edx+0ACh]		;eax = insa sayisi
    and 	eax,0FFFFh			;bu duzeltmeyi yapmayinca win7de hata aliyoruz
    print 	ustr$(eax),13,10,13,10
    
	pop		eax
	
	.if eax == 10;windoze 10
		mov dword ptr rtlOsvx.dwOSVersionInfoSize, sizeof rtlOsvx
		invoke RtlGetVersion, addr rtlOsvx
		print "Displaying Version Info via RtlGetVersion API",13,10
		print 	   chr$("Windows Version...........:"),9
		print str$(rtlOsvx.dwMajorVersion),46
		print str$(rtlOsvx.dwMinorVersion),46
		print str$(rtlOsvx.dwBuildNumber),13,10
		print cat$(chr$("Major Version.............:"), chr$(9),str$(rtlOsvx.dwMajorVersion)),13,10
		print cat$(chr$("Minor Version.............:"), chr$(9),str$(rtlOsvx.dwMinorVersion)),13,10
		print cat$(chr$("Build Number..............:"), chr$(9),str$(rtlOsvx.dwBuildNumber)),13,10
		print cat$(chr$("Platform ID...............:"), chr$(9),str$(rtlOsvx.dwPlatformId)),13,10
		print           "Service Pack String.......:",9
		print addr rtlOsvx.szCSDVersion
		print chr$(13,10)
		print cat$(chr$("Service Pack Major Version:"), chr$(9),str$(rtlOsvx.wServicePackMajor)),13,10
		print cat$(chr$("Service Pack Minor Version:"), chr$(9),str$(rtlOsvx.wServicePackMinor)),13,10
		
		invoke wrd2bin_ex,rtlOsvx.wSuiteMask, addr binBuff;hýzlý bir WORD 'den binary-ikilik dönüþtürücü
		push edx
		print cat$(chr$("Suite Mask Binary.........:"), chr$(9))
		pop edx
		print edx,13,10
		print cat$(chr$("Suite Mask Word...........:"), chr$(9),str$(rtlOsvx.wSuiteMask)),13,10
		;Eðer szCSDVersion degiskenini BYTE tanimlarsam Win10 "0" donduruyor
		;Eðer szCSDVersion degiskenini WORD tanimlarsam Win10 olmasi gerekeni donduruyor
		print cat$(chr$("Product Type..............:"), chr$(9),str$(rtlOsvx.wProductType)),13,10
		.if rtlOsvx.wProductType==VER_NT_WORKSTATION;1
			print "Windows 2000 or later professional version",13,10,13,10
		.elseif rtlOsvx.wProductType==VER_NT_SERVER;3
			print "Windows 2000 or later server",13,10,13,10
		.elseif rtlOsvx.wProductType==VER_NT_DOMAIN_CONTROLLER;2
			print "Windows 2000 or later domain controller",13,10,13,10
		.else
			print "Product Type returned something different from 1,2 or 3",13,10,13,10
		.endif
		
		print "Displaying Version Info Via Registry",13,10
		invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,addr szRegPath,0,KEY_ALL_ACCESS, addr hKey
		xor eax,eax
		invoke RegQueryValueEx,hKey, addr szRegWin10Maj, eax, eax, addr genelTampon, addr szBufferMajor
		mov esi,dword ptr ds:genelTampon
		invoke wsprintf,addr bufferMajor,addr format,esi	;donen deger tamsayi "REG_DWORD" onu cevirmeliyiz
		invoke StdOut, addr bufferMajor
		print chr$(46)
		xor eax,eax
		invoke RegQueryValueEx,hKey, addr szRegWin10Min, eax, eax, addr genelTampon, addr szBufferMinor
		mov esi,dword ptr ds:genelTampon
		invoke wsprintf,addr bufferMinor,addr format,esi
		invoke StdOut, addr bufferMinor
		print chr$(13,10)
		xor eax,eax
		invoke RegQueryValueEx,hKey, addr szProductName, eax, eax, addr bufferProductN, addr szBufferProductN
		invoke StdOut, addr bufferProductN
		print chr$(13,10,13,10)
		
		
		;MsVcRT.dll içindeki komutlarý kullanarak da versiyon bilgisi elde etmek olanakli ama yanlis sonuc uretiyor
		print "Displaying Version Info From MsVcrt.dll",13,10
		print "Gives Wrong Version Information :/",13,10
		invoke LoadLibrary,addr szLibraryPath
		.if eax
			mov edi, eax
			invoke GetProcAddress,edi,addr szMajorVersion
			.if eax
				lea ecx, dwMajorVersion
				push ecx
				call eax
				pop eax
			.endif
			invoke GetProcAddress,edi, addr szMinorVersion
			.if eax
				lea ecx, dwMinorVersion
				push ecx
				call eax
				pop eax
			.endif
			invoke GetProcAddress,edi, addr szWinVer
			.if eax
				lea ecx, dwWinVer
				push ecx
				call eax
				pop eax
			.endif
			invoke FreeLibrary,edi
		.endif
		print 	   chr$("Windows Version...........:"),9
		mov eax, dwMajorVersion
		print str$(eax)
		print chr$(46)
		mov eax, dwMinorVersion
		print str$(eax)
		print chr$(46)
		mov eax, dwWinVer
		print str$(eax)
		print chr$(13,10)

	.elseif eax == 6
		;6.0 Windows Vista 				Jan 2007
		;6.0 Windows Server 2008 (SP1)	Mar 2008
		;6.1 Windows 7 					Oct 2009
		;6.1 Windows Server 2008 R2 	Oct 2009
		;6.2 Windows 8 					Oct 2012
		;6.2 Windows Server 2012 		Oct 2012
		;6.3 Windows 8.1 				Oct 2013
		;6.3 Windows Server 2012 R2 	Oct 2013
		print "Displaying Version Info via GetVersionExA API",13,10
		mov dword ptr osvxa.dwOSVersionInfoSize, sizeof osvxa
		invoke GetVersionExA,addr osvxa
		print      chr$("Windows Version...........:"),9
		print str$(osvxa.dwMajorVersion),46
		print str$(osvxa.dwMinorVersion),46
		print str$(osvxa.dwBuildNumber),13,10
		print cat$(chr$("Major Version.............:"), chr$(9),str$(osvxa.dwMajorVersion)),13,10
		print cat$(chr$("Minor Version.............:"), chr$(9),str$(osvxa.dwMinorVersion)),13,10
		print cat$(chr$("Build Number..............:"), chr$(9),str$(osvxa.dwBuildNumber)),13,10
		print           "Service Pack String.......:",9
		print addr osvxa.szCSDVersion						;buradaki deger ANSI
		print chr$(13,10)
		print chr$("Service Pack Version......:"),9
		print cat$(str$(osvxa.wServicePackMajor),chr$(46),str$(osvxa.wServicePackMinor)),13,10
		print cat$(chr$("Service Pack Major Version:"), chr$(9),str$(osvxa.wServicePackMajor)),13,10
		print cat$(chr$("Service Pack Minor Version:"), chr$(9),str$(osvxa.wServicePackMinor)),13,10,13,10
		
		
		print "Displaying Version Info via RtlGetVersion API",13,10
		mov dword ptr rtlOsvx.dwOSVersionInfoSize, sizeof rtlOsvx
		invoke RtlGetVersion, addr rtlOsvx
		print      chr$("Windows Version...........:"),9
		print str$(rtlOsvx.dwMajorVersion),46
		print str$(rtlOsvx.dwMinorVersion),46
		print str$(rtlOsvx.dwBuildNumber),13,10
		print cat$(chr$("Major Version.............:"), chr$(9),str$(rtlOsvx.dwMajorVersion)),13,10
		print cat$(chr$("Minor Version.............:"), chr$(9),str$(rtlOsvx.dwMinorVersion)),13,10
		print cat$(chr$("Build Number..............:"), chr$(9),str$(rtlOsvx.dwBuildNumber)),13,10
		print cat$(chr$("Platform ID...............:"), chr$(9),str$(rtlOsvx.dwPlatformId)),13,10
		print           "Service Pack String.......:",9		;buradaki deger ise UNICODE
		;print addr rtlOsvx.szCSDVersion					;bu komut ile ANSI yazdirabiliyoruz
		;print chr$(13,10)
		invoke StdOutW, addr rtlOsvx.szCSDVersion			;StdOutW, sondaki W 'ya dikkat o iste Unidode demek
		print chr$(13,10)
		print cat$(chr$("Service Pack Major Version:"), chr$(9),str$(rtlOsvx.wServicePackMajor)),13,10
		print cat$(chr$("Service Pack Minor Version:"), chr$(9),str$(rtlOsvx.wServicePackMinor)),13,10
		
		
		invoke wrd2bin_ex,rtlOsvx.wSuiteMask, addr binBuff
		push edx
		print cat$(chr$("Suite Mask Binary.........:"), chr$(9))
		pop edx
		print edx,13,10
		print cat$(chr$("Suite Mask Word...........:"), chr$(9),str$(rtlOsvx.wSuiteMask)),13,10
		
		;Asagidaki bilgiyi MSDN sitesinden aldim:
		print cat$(chr$("Product Type..............:"), chr$(9),str$(rtlOsvx.wProductType)),13,10
		.if rtlOsvx.wProductType==VER_NT_WORKSTATION;1
			print "Windows 2000 or later professional version",13,10
		.elseif rtlOsvx.wProductType==VER_NT_SERVER;3
			print "Windows 2000 or later server",13,10
		.elseif rtlOsvx.wProductType==VER_NT_DOMAIN_CONTROLLER;2
			print "Windows 2000 or later domain controller",13,10
		.endif
		print chr$(13,10,13,10)
		
		print "Displaying Version Info Via Registry",13,10
		invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,addr szRegPath,0,KEY_ALL_ACCESS, addr hKey
		xor eax,eax
		invoke RegQueryValueEx,hKey, addr szRegWinCV, eax, eax, addr genelTampon, addr szBufferMajor
		;mov esi,dword ptr ds:genelTampon
		;invoke wsprintf,addr bufferMajor,addr format,esi
		invoke StdOut, addr genelTampon							;donen deger string dogrudan yazdirabiliriz "REG_SZ"
		print chr$(13,10)
		xor eax,eax
		invoke RegQueryValueEx,hKey, addr szProductName, eax, eax, addr bufferProductN, addr szBufferProductN
		invoke StdOut, addr bufferProductN
		print chr$(13,10,13,10)
		
		print "Displaying Version Info From MsVcrt.dll",13,10
		print "Gives Wrong Version Information :/",13,10
		invoke LoadLibrary,addr szLibraryPath
		.if eax
			mov edi, eax
			invoke GetProcAddress,edi,addr szMajorVersion
			.if eax
				lea ecx, dwMajorVersion
				push ecx
				call eax
				pop eax
			.endif
			invoke GetProcAddress,edi, addr szMinorVersion
			.if eax
				lea ecx, dwMinorVersion
				push ecx
				call eax
				pop eax
			.endif
			invoke GetProcAddress,edi, addr szWinVer
			.if eax
				lea ecx, dwWinVer
				push ecx
				call eax
				pop eax
			.endif
			invoke FreeLibrary,edi
		.endif
		print 	   chr$("Windows Version...........:"),9
		mov eax, dwMajorVersion
		print str$(eax)
		print chr$(46)
		mov eax, dwMinorVersion
		print str$(eax)
		print chr$(46)
		mov eax, dwWinVer
		print str$(eax)
		print chr$(13,10)

	.elseif eax == 5
		;5.0 Windows 2000				Dec 1999
		;5.1 Windows XP					Aug 2001
		;5.2 Windows Server 2003		Mar 2003
		;5.2 Windows Server 2003 R2		Dec 2005
		
		;WORKS ON XP
		print "Displaying Version Info via GetVersionExA API",13,10
		mov dword ptr osvx.dwOSVersionInfoSize, sizeof osvx
		invoke GetVersionEx,addr osvx
		print      chr$("Windows Version...........:"),9
		print str$(osvx.dwMajorVersion),46
		print str$(osvx.dwMinorVersion),46
		print str$(osvx.dwBuildNumber),13,10
		print cat$(chr$("Major Version.............:"), chr$(9),str$(osvx.dwMajorVersion)),13,10
		print cat$(chr$("Minor Version.............:"), chr$(9),str$(osvx.dwMinorVersion)),13,10
		print cat$(chr$("Build Number..............:"), chr$(9),str$(osvx.dwBuildNumber)),13,10
		print           "Service Pack String.......:",9
		print addr osvx.szCSDVersion
		print chr$(13,10,13,10)
		
		print "Displaying Version Info via GetVersionExA API",13,10
		mov dword ptr osvxa.dwOSVersionInfoSize, sizeof osvxa
		invoke GetVersionEx,addr osvxa
		print      chr$("Windows Version...........:"),9
		print str$(osvxa.dwMajorVersion),46
		print str$(osvxa.dwMinorVersion),46
		print str$(osvxa.dwBuildNumber),13,10
		print cat$(chr$("Major Version.............:"), chr$(9),str$(osvxa.dwMajorVersion)),13,10
		print cat$(chr$("Minor Version.............:"), chr$(9),str$(osvxa.dwMinorVersion)),13,10
		print cat$(chr$("Build Number..............:"), chr$(9),str$(osvxa.dwBuildNumber)),13,10
		print           "Service Pack String.......:",9
		print addr osvxa.szCSDVersion
		print chr$(13,10)
		print           "Service Pack Version......:",9
		print cat$(str$(osvxa.wServicePackMajor),chr$(46),str$(osvxa.wServicePackMinor)),13,10
		print cat$(chr$("Service Pack Major Version:"), chr$(9),str$(osvxa.wServicePackMajor)),13,10
		print cat$(chr$("Service Pack Minor Version:"), chr$(9),str$(osvxa.wServicePackMinor)),13,10,13,10
		
		
		print "Displaying Version Info via GetVersion API:",13,10
		;GetVersion APIsi parametre almýyor. Dogrudan cagiriyoruz ve dondurdugu deger "eax" yazmacina atiyor
		;Yani OSVERSIONINFO yapisini buna tanimlamaya gerek yok. Baska degiskenlere de eax'ten cektigimiz veriyi atabiliriz
		;Ben daha anlasilir olmasi icin yapiyi kullandim =)
		mov dword ptr osv.dwOSVersionInfoSize, sizeof osv
		invoke GetVersion
		xor ebx,ebx
		mov bl,al
		mov osv.dwMajorVersion,ebx
		mov bl,ah
		mov osv.dwMinorVersion,ebx
		shr eax,16
		mov osv.dwBuildNumber,eax
		print      chr$("Windows Version...........:"),9
		print str$(osv.dwMajorVersion),46
		print str$(osv.dwMinorVersion),46
		print str$(osv.dwBuildNumber),13,10
		print addr osv.szCSDVersion
		print chr$(13,10,13,10)
		
		print "Displaying Version Info Via Registry",13,10
		invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,addr szRegPath,0,KEY_ALL_ACCESS, addr hKey
		xor eax,eax
		invoke RegQueryValueEx,hKey, addr szRegWinCV, eax, eax, addr genelTampon, addr szBufferMajor
		invoke StdOut, addr genelTampon
		print chr$(13,10)
		xor eax,eax
		invoke RegQueryValueEx,hKey, addr szProductName, eax, eax, addr bufferProductN, addr szBufferProductN
		invoke StdOut, addr bufferProductN
		print chr$(13,10,13,10)
		
	.elseif eax == 4
		;4.0 Windows NT 4.0				Jul 1996
	.elseif eax == 3
		;3.1 Windows NT 3.1				Jul 1993
		;3.5 Windows NT 3.5				Sep 1994
		;3.51Windows NT 3.51			May 1995
	.else
		print "Which century is this?"
	.endif

    ret

main endp

end start