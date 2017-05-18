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
; [SCT] Keygen Template for SCTZine
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: Errorınside <errorinside@sctzine.com>
; IDE		: RADAssembler v2.2.2.1 <http://masm32.com/board/index.php?board=24.0>
; Taslak	: BlueDeviL // SCT
; Tarih		: 28/06/2016
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com
.586					;kullandığımız opcodeların hangi işlemci setine bağlı olduğu
.model flat, stdcall	;32 bit hafıza modeli
option casemap :none	;büyük küçük harfe duyarlı

include GifliKeygen.inc

.code

start:

	invoke	GetModuleHandle,NULL
	mov		hInstance,eax
	invoke	LoadCursor,NULL,IDC_HAND;linke yükleyeceğimiz imlecin handle'ını al
	mov		hImlec,eax
    invoke	InitCommonControls
    
	invoke	DialogBoxParam,hInstance,pencere,NULL,addr PencereIslemi,NULL
	
	invoke	ExitProcess,0

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
	invoke InitAniGIF
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke LoadIcon,hInstance,5001
		invoke SendMessage,hWin,WM_SETICON,ICON_SMALL,eax
		invoke uFMOD_PlaySong,500,hInstance,XM_RESOURCE	;arkafon müziği çalıştıran fonksiyon
		invoke SaydamPencere,hWin,TransparanDerece		;pencereyi saydam yapan işlem
		
		invoke GetDlgItem,hWin,edtSerial
		mov hSerial,eax
		
		;İmlecYukle işlemini lblLink ile ilişkilendir
		invoke GetDlgItem,hWin,lblLink
		push eax
		invoke SetWindowLong,eax,GWL_WNDPROC,ADDR ImlecYukle
		pop edx
		invoke SetWindowLong,edx,GWL_USERDATA,eax
		
	.elseif eax==WM_COMMAND
		mov eax,wParam
		mov edx,wParam
		shr edx,16
		
		.if dx==BN_CLICKED
			.if ax==lblLink				;web adresimizin olduğu yere mi tıklandı??
				invoke ShellExecute,hWin,ADDR TarayiciyaGit,ADDR SCTweb,NULL,NULL,0
			.endif
		.endif
		
		.if ax==btnUret					;kullancı üret tuşuna mı bastı?
			invoke SerialUret,hWin
			invoke RtlZeroMemory,addr szSerial, sizeof szSerial
			invoke RtlZeroMemory,addr szBuff1, sizeof szBuff1
		.endif
		.if ax==btnKapat				;eğer kullanıcı Çıkış tuşuna basarsa
			invoke EndDialog,hWin,0		;pencereyi kapat
			ret
		.endif
		
		.if ax==btnHakkinda				;hakkında butonuna basıldıysa
			invoke MessageBox,hWin,ADDR msgHakkinda,ADDR msgBaslik,MB_OK
			ret
		.endif
		.if ax==btnKopyala
			invoke SendMessage,hSerial,EM_SETSEL,0,-1	;seriali seç
			invoke SendMessage,hSerial,WM_COPY,0,0		;seriali panoya kopyala
			invoke SendMessage,hSerial,EM_SETSEL,-1,0	;seriali seçme
			xor eax,eax
			ret
		.endif
	.elseif eax==WM_CLOSE
		invoke uFMOD_PlaySong,0,0,0
		invoke  EndDialog, hWin, 0
	.else
		mov		eax,FALSE
		ret
	.endif
	invoke TerminateAniGIF
	mov		eax,TRUE
	ret

PencereIslemi endp

SerialUret proc uses ebx edi esi,hWin:DWORD

			invoke GetDlgItemText,hWin,edtAd,addr szName,MAXSIZE;isim bu api ile alınıyor
			cmp eax,0											;kullanıcı isim girmediyse eax=0
			je _isimyok											;isim yoksa dallan
			
			invoke lstrcat, addr szBuff1, addr szName
			invoke lstrcpy,addr szSerial,chr$('SCTZine-')		;keygene göre ilk 9 karakter rEdArEnA+ olmalı, szSerial değişkenine önce bunu kopyalıyoruz
			invoke lstrcat,addr szSerial,addr szBuff1			;szSerial ve szBuff1 deki veriler birbirne eklenerek szSeriale yazılıyor
			invoke SetDlgItemText,hWin,edtSerial,addr szSerial	;edite seriali yazdırıyoruz
			_Son:
			xor eax,eax
			ret
			
			_isimyok:
			invoke SetDlgItemText,hWin,edtSerial,chr$('İsim Giriniz!')
			jmp _Son
SerialUret endp

SaydamPencere proc hWin:dword, SaydamDeger:dword

	pushad
	invoke GetModuleHandle,chr$("user32.dll")
	invoke GetProcAddress,eax,chr$("SetLayeredWindowAttributes")
	.if eax!=0
		invoke GetWindowLong,hWin,GWL_EXSTYLE	;get EXSTYLE
		
		.if SaydamDeger==255
			xor eax,WS_EX_LAYERED	;remove WS_EX_LAYERED
		.else
			or eax,WS_EX_LAYERED	;eax = oldstlye + new style(WS_EX_LAYERED)
		.endif
		
		invoke SetWindowLong,hWin,GWL_EXSTYLE,eax
		
		.if SaydamDeger<255
			invoke SetLayeredWindowAttributes,hWin,0,SaydamDeger,LWA_ALPHA
		.endif	
	.endif
	popad
	ret
SaydamPencere endp

end start
