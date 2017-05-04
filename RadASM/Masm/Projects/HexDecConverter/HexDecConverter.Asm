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
; HexDecConverter v1.0
; _______________________________________________________________________________
; Yazar		: BlueDeviL <blau_devil@hotmail.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.2.0 <http://radasm.cherrytree.at/>
; Taslak	: BlueDeviL // SCT
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com

.386					;kullandýðýmýz opcodelarýn hangi iþlemci setine baðlý olduðu
.model flat, stdcall	;32 bit hafýza modeli
option casemap :none	;büyük küçük harfe duyarlý

include HexDecConverter.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,pencere,NULL,addr PencereIslemi,NULL
	invoke ExitProcess,0

PencereIslemi proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
	invoke LoadIcon,hInstance,5001
	invoke SendMessage,hWin,WM_SETICON,ICON_BIG,eax
	invoke SendDlgItemMessage,hWin,edtHEX,EM_LIMITTEXT,8,0		;edtHEX max 8 karakter ile sýnýrlandýr
	invoke SendDlgItemMessage,hWin,edtDECU,EM_LIMITTEXT,0Ah,0	;edtDECU max 10 karakter ile sýnýrlandýr
	invoke SendDlgItemMessage,hWin,edtDECS,EM_LIMITTEXT,0Bh,0	;edtDECS max 11 karakter ile sýnýrlandýr(- karakteride var;)
	invoke GetDlgItem,hWin,edtHEX								;edtHEX editinin "handle"ýný al eax'e yaz
	invoke SetWindowLong,eax,GWL_WNDPROC,addr EditAFKontrolu	;SetWindowLong APIsi ile EditAFKontrolu fonksiyonunda
																;belirttiðimiz þekilde edtHEX editinin davranýþýný
																;deðiþtir.Biz bu fonk. ile bu edite sadece 0-9 ve A-F
																;karakterlerinin yazýlabilmesine izin verdik.
	mov EskiPenIslemi,eax
	
	invoke GetDlgItem,hWin,edtDECS
	invoke SetWindowLong,eax,GWL_WNDPROC,addr Edit09Kontrolu
	mov EskiPenIslemi,eax
	mov kntrlBAYRAK,TRUE

	.elseif eax==WM_COMMAND
	mov eax,wParam
	mov edx,wParam
	shr edx,16
		.if dx==BN_CLICKED
			.if ax==btnKAPAT
				invoke SendMessage,hWin,WM_CLOSE,0,0
			.elseif ax==btnYARDIM
				invoke MessageBox,hWin,addr msgYardim,addr msgBaslik,MB_APPLMODAL
			.endif
		.endif
		shr eax,16
		.if ax==EN_SETFOCUS
			invoke SendMessage,lParam,WM_GETTEXT,32h,addr tampon2
		.elseif ax==(EN_UPDATE) && (kntrlBAYRAK)
			invoke SendMessage,lParam,WM_GETTEXT,32h,addr tampon1
			mov ecx,eax
			mov eax,wParam
			and eax,0000FFFFh
			.if ax==edtHEX
				mov kntrlBAYRAK,FALSE
				invoke HexOlarakAl,addr tampon1,ecx
				invoke wsprintf,addr tampon2,addr formatu,ebx
				invoke SetDlgItemText,hWin,edtDECU,addr tampon2
				invoke wsprintf,addr tampon3,addr formats,ebx
				invoke SetDlgItemText,hWin,edtDECS,addr tampon3
				mov kntrlBAYRAK,TRUE
			.elseif ax==edtDECU
				mov kntrlBAYRAK,FALSE
				invoke On2OnA,addr tampon1
				invoke SetDlgItemText,hWin,edtHEX,addr CikanDeger2
				invoke wsprintf,addr tampon3E,addr formats,ebx
				invoke SetDlgItemText,hWin,edtDECS,addr tampon3E
				mov kntrlBAYRAK,TRUE
			.elseif ax==edtDECS
				mov kntrlBAYRAK,FALSE
				invoke On2OnA,addr tampon1
				invoke SetDlgItemText,hWin,edtHEX,addr CikanDeger2
				invoke wsprintf,addr tampon2E,addr formatu,ebx
				invoke SetDlgItemText,hWin,edtDECU,addr tampon2E
				mov kntrlBAYRAK,TRUE
			.endif
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

comment *
HexOlarakAl fonksiyonunu kullanýcýnýn edite girdiði 32bitlik HEX deðerini alýp
ebx yazmacýna (oradanda CikanDeger deðiþkenine) yazdýrmak için yazdým. Böylece
Yazmacýn bir tanesinde kullanýcýnýn girmiþ olduðu hex deðerini kolaylýkla kull
anabilmiþ oluyorum.
*
HexOlarakAl proc GelenDeger:DWORD,GelenUzunluk:DWORD

mov esi,GelenDeger
mov ecx,GelenUzunluk
xor ebx,ebx


donguB:
shl ebx,4
dongu:
xor eax,eax
lodsb
push ecx
cmp al,30h
jb _son
cmp al,39h
ja _AFKontrol
sub al,30h
_devam:
add bl,al
pop ecx
loop donguB
mov CikanDeger,ebx
_son:

ret

_AFKontrol:
cmp al,41h
jb _son
cmp al,46h
ja _son
sub al,37h
jmp _devam

HexOlarakAl endp

comment *
On2OnA fonksiyonu en basit haliyle onluk bir sayýyý onaltýlýk bir sayýya çevir
meye yarýyor.Ýkinci wsprintf ile çevrilen deðer ise yukarýda incelerseniz onlu
k olan sayýnýn signed-unsigned arasý dönüþümü yapabilmek için tampona attýðým
hex deðerini döndürüyor.
*
On2OnA proc GelenDeger:DWORD

	
	invoke StrToInt,addr tampon1
	mov ebx,eax
	invoke wsprintf,addr CikanDeger2,addr formatX,eax
	invoke wsprintf,addr CikanDeger3,addr formatx,ebx
	
	
	ret

On2OnA endp

comment *
EditAFKontrolu bizim SubClassing için kullandýðýmýz 2 fonkisyondan birisi. Aþa
ðýdaki fonksiyonda edite sadece A-F, 0-9 ve Backspace tuþalarýnýn kullanýmýna
izin veriyoruz. Bu fonksiyomun iþlemesi için ise PencereIsleminin WM_INITDIALOG
bölümünde önce davranýþýný deðiþtireceðimiz editin handlený alýp daha sonrada
"SetWindowLong" APIsi ile aþaðýdaki foksiyonu çaðýrarak editimizin davranýþýný 
deðiþtiriyoruz.

Bir alttaki fonksiyonda ise "Signed Integer" edtDECS editinin davranýþýný deði
þtirecek olan fonksiyon var orada da dikkat ederseniz edite sadece 0-9, "-" ve
Backspace tuþalrýnýn kullanýmna izin verdim.

Not:Bu subclassing iþlemini Iczelionun Subclassing dersinden düzenleyerek buraya
ekledim.
*
EditAFKontrolu proc hEdit:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	
	.if uMsg==WM_CHAR
		mov eax,wParam
		.if (al>="0" && al<="9") || (al>="A" && al<="F") || (al>="a" && al<="f") || al==VK_BACK
			.if al>="a" && al<="f"
				sub al,20h
			.endif
			invoke CallWindowProc,EskiPenIslemi,hEdit,uMsg,eax,lParam
			ret
		.else
			invoke MessageBeep,0FFFFFFFFh
		.endif
		ret
	.else
	invoke CallWindowProc,EskiPenIslemi,hEdit,uMsg,wParam,lParam
	.endif
	ret

EditAFKontrolu endp

Edit09Kontrolu proc hEdit:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	
	.if uMsg==WM_CHAR
		mov eax,wParam
		.if (al>="0" && al<="9") || al=="-" || al==VK_BACK
			invoke CallWindowProc,EskiPenIslemi,hEdit,uMsg,eax,lParam
			ret
		.else
			invoke MessageBeep,0FFFFFFFFh
		.endif
		ret
	.else
	invoke CallWindowProc,EskiPenIslemi,hEdit,uMsg,wParam,lParam
	.endif
	ret

Edit09Kontrolu endp

end start
