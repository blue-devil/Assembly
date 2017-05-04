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
; HexBinConverter v1.0
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

include HexBinConverter.inc

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
	invoke SendDlgItemMessage,hWin,edtBIN,EM_LIMITTEXT,20h,0	;edtBIN max 32 karakter ile sýnýrlandýr
	invoke GetDlgItem,hWin,edtHEX								;edtHEX editinin "handle"ýný al eax'e yaz
	invoke SetWindowLong,eax,GWL_WNDPROC,addr EditAFKontrolu	;SetWindowLong APIsi ile EditAFKontrolu fonksiyonunda
																;belirttiðimiz þekilde edtHEX editinin davranýþýný
																;deðiþtir.Biz bu fonk. ile bu edite sadece 0-9 ve A-F
																;karakterlerinin yazýlabilmesine izin verdik.
	mov EskiPenIslemi,eax
	
	invoke GetDlgItem,hWin,edtBIN								;edtHEX editinin "handle"ýný al eax'e yaz
	invoke SetWindowLong,eax,GWL_WNDPROC,addr EditIkiKontrolu	;SetWindowLong APIsi ile EditIkiKontrolu fonksiyonunda
																;belirttiðimiz þekilde edtBIN editinin davranýþýný
																;deðiþtir.Biz bu fonk. ile bu edite sadece 0-1
																;karakterlerinin yazýlabilmesine izin verdik.
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
			invoke SendMessage,lParam,WM_GETTEXT,24h,addr tampon2
		.elseif ax==(EN_UPDATE) && (kntrlBAYRAK)
			invoke SendMessage,lParam,WM_GETTEXT,24h,addr tampon1
			mov ecx,eax
			mov eax,wParam
			and eax,0000FFFFh
			.if ax==edtHEX
				mov kntrlBAYRAK,FALSE
				invoke HexOlarakAl,addr tampon1,ecx
				mov eax,ebx
				push eax
				push ebx
				invoke OnA2Iki,eax
				invoke wsprintf,addr tampon3,addr formatubits,eax
				invoke SetDlgItemText,hWin,lblBITS,addr tampon3
				invoke SetDlgItemText,hWin,edtBIN,addr tampon2
				invoke SetDlgItemText,hWin,edtBIN2,addr tampon2
				pop ebx
				pop eax
				invoke wsprintf,addr tampon3,addr formats,ebx
				invoke SetDlgItemText,hWin,edtDEC,addr tampon3
				mov kntrlBAYRAK,TRUE
			.elseif ax==edtBIN
				mov kntrlBAYRAK,FALSE
				
				sub eax,eax
				mov ebx,ecx
				or ebx,ebx
				je _islemyapma
				invoke Iki2OnA,addr tampon1,ecx
				
				_islemyapma:
				mov tampon4,ebx;ebx'de HEX deðerim var
				;aþaðýdaki 2 kodla kaç bitlik 2lik deðer girdiðimi yazdýrýyorum
				invoke wsprintf,addr tampon2E,addr formatubits,ecx
				invoke SetDlgItemText,hWin,lblBITS,addr tampon2E
				
				;aþaðýdaki 2 kodla edtHEX'e girdiðim ikilik deðerin HEX karþýlýðýný yazdýrýyorum
				invoke wsprintf,addr tampon3E,addr formatX,tampon4
				invoke SetDlgItemText,hWin,edtHEX,addr tampon3E
				
				;aþaðýdaki 2 kodl ile de ikilik deðerin onluk karþýlýðýný yazdýrýyorum
				invoke wsprintf,addr tampon1E,addr formats,ebx
				invoke SetDlgItemText,hWin,edtDEC,addr tampon1E
				
				;invoke OnA2Iki,tampon4
				invoke SetDlgItemText,hWin,edtBIN2,addr tampon1
				
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
OnA2Iki iþlemi onaltýlýk bir sayýyý  ikilik bir sayýya çevirmek için  yazdýðým
bir iþlemdir. Intel Opcodelarýnda BT olarak tanýmlanmýþ "Bit Test" komutu var.
Bu komut ile yazmaca aldýðýmýz sayýnýn her bir bitini test ederek tekrar yazdý
rýyoruz. Yazdýrdýðýmýz rakamlar bize o sayýnýn ikilik deðerini veriyor
*

OnA2Iki proc GelenDeger:DWORD

mov edi,offset tampon2
mov ecx,1Fh
xor ebx,ebx
xchg edx,eax

_BitKontrol:
bt edx,ecx
setb al
or al,30h
stos byte ptr es:[edi]
dec ecx
jns _BitKontrol

mov ecx,20h
xchg edi,esi
sub esi,ecx

_DonguHB:
lods byte ptr ds:[esi]
cmp al,31h
je _DonguHB2
loopd _DonguHB
_DonguHB2:
xchg eax,ecx
pop edi
pop esi
pop edx
pop ecx

ret

OnA2Iki endp

comment *
Iki2OnA iþlemi adýndan da anlaþýlacaðý gibi ikilik bir sayýyý onaltýlýk deðere
dönüþtürmeye yarar.
*
Iki2OnA proc GelenDeger:DWORD,GelenUzunluk:DWORD

push eax
push ecx
push edi
sub eax,eax
xor edi,edi
mov ecx,GelenUzunluk
mov esi,offset tampon1
_donbasa:
lods byte ptr[esi]
or al,al
je _SayilarBitti
sub al,30h
_SayilarBitti:
add edi,edi
or edi,eax
dec ecx
jnz _donbasa
mov tampon3,edi
mov ebx,edi

;sonradan eklendi
mov ecx,GelenUzunluk
mov esi,offset tampon1
_basi:
lods byte ptr[esi]
cmp al,31h
je _dallan
loopd _basi
_dallan:
;buraya kadar
pop edi
;pop ecx
pop eax

ret

Iki2OnA endp

comment *
EditAFKontrolu bizim SubClassing için kullandýðýmýz 2 fonkisyondan birisi. Aþa
ðýdaki fonksiyonda edite sadece A-F, 0-9 ve Backspace tuþalarýnýn kullanýmýna
izin veriyoruz. Bu fonksiyomun iþlemesi için ise PencereIsleminin WM_INITDIALOG
bölümünde önce davranýþýný deðiþtireceðimiz editin handlený alýp daha sonrada
"SetWindowLong" APIsi ile aþaðýdaki foksiyonu çaðýrarak editimizin davranýþýný 
deðiþtiriyoruz.

Bir alttaki fonksiyonda ise edit binary(ikilik) olduðu için sadece "0" ve "1"
karakterlerinin yazdýrýlabilmesine ve yine Backspace tuþunun kullanýlabilmesine
izin verdim.

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

EditIkiKontrolu proc hEdit:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
.if uMsg==WM_CHAR
	mov eax,wParam
	.if (al>="0" && al<="1") || al==VK_BACK
		invoke CallWindowProc,EskiPenIslemi,hEdit,uMsg,eax,lParam
		ret
	.else
		invoke MessageBeep,0FFFFFFFFh
	.endif
.else
	invoke CallWindowProc,EskiPenIslemi,hEdit,uMsg,wParam,lParam
	ret
.endif
xor eax,eax
ret
EditIkiKontrolu endp

end start
