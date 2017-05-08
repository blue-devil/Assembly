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
; Rastgele Real Sayı Üreteci
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.2.0 <radasm.cherrytree.at>
; Taslak	: BlueDeviL // SCT
; Tarih		: 04/08/2012
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com
.586					;kullandığımız opcodeların hangi işlemci setine bağlı olduğu
.model flat, stdcall	;32 bit hafıza modeli
option casemap :none	;büyük küçük harfe duyarlı

include RastgeleRealSayi.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax
	invoke LoadCursor,NULL,IDC_HAND;linke yükleyeceğimiz imlecin handle'ını al
	mov hImlec,eax
    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,pencere,NULL,addr PencereIslemi,NULL
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

PencereIslemi proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke LoadIcon,hInstance,5001		;ikonumuzu ekledik
											;ancak prog. çalışınca sol üstte ikon yok
											;bunu gidermek için ise:
		mov hIkon,eax
		invoke SendMessage,hWin,WM_SETICON,ICON_SMALL,hIkon;ile
		;pencereye de ikon ekliyoruz
		
		;Liste kutularımızın handlelarını alıyoruz
		invoke GetDlgItem,hWin,lst0dan1e
		mov hListeKutusu,eax
		invoke GetDlgItem,hWin,lst1den10a
		mov hListeKutusu2,eax
		invoke RassalReelUret,hWin				;sonra da rassal reel üret

		;İmlecYukle işlemini lblLINK ile ilişkilendir
		invoke GetDlgItem,hWin,lblLINK
		push eax
		invoke SetWindowLong,eax,GWL_WNDPROC,ADDR ImlecYukle
		pop edx
		invoke SetWindowLong,edx,GWL_USERDATA,eax
		
	.elseif eax==WM_CTLCOLORSTATIC				;colorstatic ile static kutusunu renklendiriyoruz
		invoke GetDlgCtrlID,lParam
		.if ax==lblLINK || lst0dan1e ||lst1den10a
			INVOKE SetBkMode, wParam, TRANSPARENT
			INVOKE SetTextColor, wParam, 00A00000h
			INVOKE GetSysColor, COLOR_BTNFACE
			INVOKE CreateSolidBrush, eax
			ret
		.endif
	.elseif eax==WM_COMMAND
		mov eax,wParam
		mov edx,wParam
		shr edx,16
		
		.if dx==BN_CLICKED
			.if ax==lblLINK				;web adresimizin olduğu yeremi tıklandı??
				invoke ShellExecute,hWin,ADDR TarayiciyaGit,ADDR SCTweb,NULL,NULL,0
			.endif
		.endif
		
		.if ax==btnUret					;kullancı üret tuşuna mı bastı?
			invoke RassalReelUret,hWin	;rassal reel üret
		.endif
		.if ax==btnKapat				;eğer kullanıcı Çıkış tuşuna basarsa
			invoke EndDialog,hWin,0		;pencereyi kapat
			ret
		.endif
		
		.if ax==btnHakkinda				;hakkında butonuna basıldıysa
			invoke MessageBox,hWin,ADDR msgHakkinda,ADDR msgBaslik,MB_OK
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

PencereIslemi endp
RassalReelUret	PROC	uses ebx edi esi,hWin:DWORD
	
	invoke Rastgele01,NULL				;0 1 arası rassal reel sayı üret
	invoke Rastgele110,NULL				;1 - 10 arası raasal reel sayı üret
	xor eax,eax
	ret

RassalReelUret endp

Rastgele01	PROC uses ebx edi esi,hWin:DWORD


	RDTSC								;time stamp counter
	invoke nseed,eax					;program her başladığında nrandomun farklı 
										;sayılarla açılmasını sağlar
	_tekrar:	
	invoke nrandom,100d					;0-99 arasında rassal sayı üretir 
	cmp eax,0
	jz _tekrar
	mov DWORD PTR DS:[tampon],eax
	finit
	fldpi								;pi sayısı yerine sabit e sayısı da kullanılabilir: "fldl2e" komutu ile
	fimul DWORD PTR DS:[tampon]
	fidiv DWORD PTR DS:[tampon2]

	invoke FpuFLtoA,0,8,addr rastsayi,SRC1_FPU	;reel sayıyı nktasıyla birlikte string olarak döndürür
												;eğer 8 yerine 4 yazarsanız noktadan sonraki 4 haneyi döndürür.
	invoke SendMessage,hListeKutusu,LB_ADDSTRING,0,addr rastsayi;listeye yaz
	ret

Rastgele01 endp

Rastgele110	PROC	uses ebx edi esi,hWin:DWORD


	RDTSC								;time stamp counter
	invoke nseed,eax					;program her başladığında nrandomun farklı 
										;sayılarla açılmasını sağlar
	_tekrar:	
	invoke nrandom,100d					;0-99 arasında rassal sayı üretir 
	cmp eax,0
	jz _tekrar
	mov DWORD PTR DS:[tampon],eax
	finit
	fldpi								;pi sayısı yerine sabit e sayısı da kullanılabilir: "fldl2e" komutu ile
	fimul DWORD PTR DS:[tampon]
	fidiv DWORD PTR DS:[tampon2]

	_tekrar2:	
	invoke nrandom,10d					;0-9 arasında rassal sayı üretir 
	cmp eax,0
	jz _tekrar2
	mov DWORD PTR DS:[tampon],eax
	fiadd DWORD PTR DS:[tampon]

	invoke FpuFLtoA,0,8,addr rastsayi,SRC1_FPU	;reel sayıyı nktasıyla birlikte string olarak döndürür
												;eğer 8 yerine 4 yazarsanız noktadan sonraki 4 haneyi döndürür.
	invoke SendMessage,hListeKutusu2,LB_ADDSTRING,0,addr rastsayi;listeye yaz
	ret

Rastgele110 endp
end start
