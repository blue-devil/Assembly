; ÌÎÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÎ?
; Ì?ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?Ì?
; Ì?? ÜÜÛÛÛÛÛÛÛÛÛ   ÜÜÛÛÛÛÛÛÛÜÜ   ÜÛÛÛÛÛÛÛÛÛÜ ?Ì?
; Ì?? ÛÛÛÛÛÛÛÛÛßß   ÛÛÛÛÛÛÛÛÛßß   ßÛÛÛÛÛÛÛÛÛß ?Ì?
; Ì?? ÛÛ            ÛÛß               ÛÛÛ     ?Ì?
; Ì?? ÛÛ            ÛÛ                ÛÛÛ     ?Ì?
; Ì?? ÛÛÛÛÛÛÛÛÛÜÜ   ÛÛ                ÛÛÛ     ?Ì?
; Ì?? ßßÛÛÛÛÛÛÛÛÛ   ÛÛ                ÛÛÛ     ?Ì?
; Ì??          ÛÛ   ÛÛ                ÛÛÛ     ?Ì?
; Ì??          ÛÛ   ÛÛÜ               ÛÛÛ     ?Ì?
; Ì?? ÜÜÛÛÛÛÛÛÛÛÛ   ÛÛÛÛÛÛÛÛÛÜÜ       ÛÛÛ     ?Ì?
; Ì?? ÛÛÛÛÛÛÛÛÛßß   ßßÛÛÛÛÛÛÛßß       ßÛß     ?Ì?
; Ì??                                         ?Ì?
; Ì??                home of secret reversers®?Ì?
; Ì?ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?Ì?
; Random Number Generator v0.2
; _______________________________________________________________________________
; Author	: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.2.0 <radasm.cherrytree.at>
; Template	: BlueDeviL // SCT
; Tarih		: 24/10/2012
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com

.586					;kullandığımız opcodeların hangi işlemci setine bağlı olduğu
						;normalde 386 kullanırım ben ama rastgele sayı üretmek için 
						;kullandığım RDTSC fonksiyonu en az .586 işlemci komut setinde
						;bulunuyor.
						;.xmm
.model flat, stdcall	;32 bit hafıza modeli
option casemap :none	;büyük küçük harfe duyarlı

include RastgeleSayi.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax
	invoke LoadCursor,NULL,IDC_HAND;linke yükleyeceğimiz imlecin handle'ını al
	mov hImlec,eax
    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,pencere,NULL,addr DlgProc,NULL
	invoke ExitProcess,0
	
	
ImlecYukle proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
;bu işlem ile linkin üzerine gelindiğinde imleç değişecek
  .if uMsg==WM_SETCURSOR
    invoke SetCursor, hImlec
  .else
    invoke GetWindowLong, hWin, GWL_USERDATA
    invoke CallWindowProc, eax, hWin, uMsg, wParam, lParam
    ret
  .endif

  xor eax, eax
  ret
ImlecYukle endp

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke LoadIcon,hInstance,5001	;ikonumuzu ekledik
										;ancak prog. çalışınca sol üstte ikon yok
										;bunu gidermek için ise:
		mov hIkon,eax
		invoke SendMessage,hWin,WM_SETICON,ICON_SMALL,hIkon;ile
		;pencereye de ikon ekliyoruz
		
		
		invoke SerialUret,hWin;sonrada seriali o isme göre üretsin
		
		;İmlecYukle işlemini lblLINK ile ilişkilendir
		invoke GetDlgItem,hWin,lblLINK
		push eax
		invoke SetWindowLong,eax,GWL_WNDPROC,ADDR ImlecYukle
		pop edx
		invoke SetWindowLong,edx,GWL_USERDATA,eax
		
		;Menü butonlarını silmek istiyorum
		;Bu sebeple önce menünün handle'ını alıyorum
		;daha sonra istediğim menü tuşlarını sileceğim
		;WM_SYSCOMMAND --> win32.hlp den inceleyin
		invoke GetSystemMenu,hWin,FALSE
		mov esi,eax
		invoke DeleteMenu,esi,SC_RESTORE,MF_BYCOMMAND;önceki boyut iptal
		invoke DeleteMenu,esi,SC_MAXIMIZE,MF_BYCOMMAND;ekranı kapla iptal
		invoke DeleteMenu,esi,SC_SIZE,MF_BYCOMMAND;boyut iptal

	.elseif eax==WM_COMMAND
		mov eax,wParam
		mov edx,wParam
		shr edx,16
		
		.if dx==BN_CLICKED
			.if ax==lblLINK;web adresimizin olduğu yeremi tıklandı??
				invoke ShellExecute,hWin,ADDR TarayiciyaGit,ADDR SCTweb,NULL,NULL,0
			.endif
		.endif
		
		.if ax==btnUret					;kullancı üret tuşuna mı bastı?
			invoke SerialUret,hWin
		.endif
		.if ax==btnCikis				;eğer kullanıcı Çıkış tuşuna basarsa
			invoke EndDialog,hWin,0		;pencereyi kapat
			ret
		.endif
		
		.if ax==btnHakkinda
			invoke MessageBox,hWin,ADDR msgHakkinda,ADDR msgBaslik,MB_OK
			ret
		.endif
		
	.elseif eax==WM_CTLCOLORSTATIC
		invoke GetDlgCtrlID,lParam
		.if ax==lblLINK || lblBirOn
			INVOKE SetBkMode, wParam, TRANSPARENT
			INVOKE SetTextColor, wParam, 00A00000h
			INVOKE GetSysColor, COLOR_BTNFACE
			INVOKE CreateSolidBrush, eax
			ret
		.endif
		
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

SerialUret	PROC	uses ebx edi esi,hWin:DWORD

invoke RastGele1,NULL
invoke wsprintf,addr milisaniye,addr format,milisaniye
invoke SetDlgItemText,hWin,edtGTC,addr milisaniye		;returning value of GetTickCount
invoke wsprintf,addr rastsayi3,addr format,rastsayi3
invoke SetDlgItemText,hWin,edtBirOn,addr rastsayi3		;random numbers between 1-10

invoke RastGele2,NULL
invoke wsprintf,addr rastsayi,addr format,rastsayi
invoke SetDlgItemText,hWin,edtRDTSC,addr rastsayi		;returning value of RDTSC

invoke RastGele3,NULL
invoke wsprintf,addr rastsayi2,addr format,rastsayi2
invoke SetDlgItemText,hWin,edtNRANDOM,addr rastsayi2	;returning value of nrandom

invoke RastGele4,NULL
invoke wsprintf,addr rastsayi4,addr format,rastsayi4
invoke SetDlgItemText,hWin,edtCryptGenRnd,addr rastsayi4;returning value of CryptGenRandom

invoke RastGele5,NULL
invoke wsprintf,addr rastsayi5,addr format,rastsayi5
invoke SetDlgItemText,hWin,edtIrvine32,addr rastsayi5	;returning value of Random32(in Irvine32Mb.lib)

invoke RastGele6,NULL
invoke wsprintf,addr rastsayi6,addr format,rastsayi6
invoke SetDlgItemText,hWin,edtIrvine322,addr rastsayi6	;returning value of RandomRange(in Irvine32Mb.lib)

invoke RastGele7,NULL
invoke wsprintf,addr rastsayi7,addr format,rastsayi7
invoke SetDlgItemText,hWin,edtRand,addr rastsayi7		;returning value of Rand() function which i exported from MasmBasic.inc
_Son:
xor eax,eax
ret

SerialUret endp

RastGele1	PROC	tampon1:DWORD
	invoke GetTickCount
	mov milisaniye,al
	;GetTickCount retrieves the number of milliseconds that have elapsed since the system was started, up to 49.7 days.
	;The return value is the number of milliseconds that have elapsed since the system was started.

	;To generate random numbers between 1-10
	;i only compare al with 10d =)
	mov rastsayi3,al
	_tekrarkontrol:
	cmp rastsayi3,10d
	ja _eksilt
	ret
	
	_eksilt:
	sub rastsayi3,10d
	jmp _tekrarkontrol
	
	
	ret

RastGele1 endp

RastGele2 PROC tampon2:DWORD
	;The Time Stamp Counter is a 64-bit register present on all x86 processors since the Pentium.
	;It counts the number of cycles since reset. The instruction "RDTSC" returns the TSC in EDX:EAX.
	;In x86-64 mode, RDTSC also clears the higher 32 bits of RAX.
	;Its opcode is 0F 31.[1] Pentium competitors such as the Cyrix 6x86 did not always
	;have a TSC and may consider RDTSC an illegal instruction. Cyrix included a Time Stamp Counter in their MII.
	;We can use RDTSC on 586 processor set

	;i only writing the returning value from RDTSC:
	RDTSC			;Time Stamp Counter
	mov rastsayi,eax
	ret

RastGele2 endp

RastGele3 PROC tampon3:DWORD
	
	RDTSC
	invoke nseed,eax	;nseed provides that nrandom generates different random numbers
						;on every call
	invoke nrandom,100d	;generates random between 0-99 
	mov rastsayi2,eax
	ret

RastGele3 endp

RastGele4 PROC tampon4:DWORD
	
	;This function acquires a handle to a specific key container within a particular
	;cryptographic service provider (CSP). This handle can be used to make calls to the selected CSP.
	invoke CryptAcquireContext,offset hPrv,0,0,PROV_RSA_FULL,CRYPT_VERIFYCONTEXT + CRYPT_SILENT
	
	;The CryptGenRandom function fills a buffer with cryptographically random bytes.
	invoke CryptGenRandom,hPrv,10,addr rastsayi4
	ret

RastGele4 endp

RastGele5 PROC tampon5:DWORD
	
	invoke Randomize	;To make random number on ever generation
	invoke Random32		;generates 32-bit random integer
	mov rastsayi5,eax
	ret

RastGele5 endp

RastGele6 PROC tampon6:DWORD
	
	invoke Randomize	;To make random number on ever generation
	mov eax,99d			;upper limit of range
	invoke RandomRange	;we can generate random integer in specified range
	mov rastsayi6,eax

	ret

RastGele6 endp

RastGele7 PROC tampon7:DWORD
	
	mov eax,Rand(1071)	;I'have exported Rand() function from MasmBasic.inc
						;you can use is as shown above. It generates integers.
						;Up limit is the number in paranthesis
	mov rastsayi7,eax
	ret

RastGele7 endp

end start
