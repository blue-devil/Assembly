; ����������������������������������������������?
; �?������������������������������������������?�?
; �?? �����������   �����������   ����������� ?�?
; �?? �����������   �����������   ����������� ?�?
; �?? ��            ���               ���     ?�?
; �?? ��            ��                ���     ?�?
; �?? �����������   ��                ���     ?�?
; �?? �����������   ��                ���     ?�?
; �??          ��   ��                ���     ?�?
; �??          ��   ���               ���     ?�?
; �?? �����������   �����������       ���     ?�?
; �?? �����������   �����������       ���     ?�?
; �??                                         ?�?
; �??                home of secret reversers�?�?
; �?������������������������������������������?�?
; [SCT] Keygen Template for SCTZine
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: Error�nside <errorinside@sctzine.com>
; IDE		: RADAssembler v2.2.2.1 <http://masm32.com/board/index.php?board=24.0>
; Taslak	: BlueDeviL // SCT
; Tarih		: 28/06/2016
; �������������������������������������������������������������������������������
;																  www.sctzine.com
.586					;kulland���m�z opcodelar�n hangi i�lemci setine ba�l� oldu�u
.model flat, stdcall	;32 bit haf�za modeli
option casemap :none	;b�y�k k���k harfe duyarl�

include GifliKeygen.inc

.code

start:

	invoke	GetModuleHandle,NULL
	mov		hInstance,eax
	invoke	LoadCursor,NULL,IDC_HAND;linke y�kleyece�imiz imlecin handle'�n� al
	mov		hImlec,eax
    invoke	InitCommonControls
    
	invoke	DialogBoxParam,hInstance,pencere,NULL,addr PencereIslemi,NULL
	
	invoke	ExitProcess,0

ImlecYukle proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
;bu i�lem ile linkin �zerine gelindi�inde imle� de�i�ecek
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
		invoke uFMOD_PlaySong,500,hInstance,XM_RESOURCE	;arkafon m�zi�i �al��t�ran fonksiyon
		invoke SaydamPencere,hWin,TransparanDerece		;pencereyi saydam yapan i�lem
		
		invoke GetDlgItem,hWin,edtSerial
		mov hSerial,eax
		
		;�mlecYukle i�lemini lblLink ile ili�kilendir
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
			.if ax==lblLink				;web adresimizin oldu�u yere mi t�kland�??
				invoke ShellExecute,hWin,ADDR TarayiciyaGit,ADDR SCTweb,NULL,NULL,0
			.endif
		.endif
		
		.if ax==btnUret					;kullanc� �ret tu�una m� bast�?
			invoke SerialUret,hWin
			invoke RtlZeroMemory,addr szSerial, sizeof szSerial
			invoke RtlZeroMemory,addr szBuff1, sizeof szBuff1
		.endif
		.if ax==btnKapat				;e�er kullan�c� ��k�� tu�una basarsa
			invoke EndDialog,hWin,0		;pencereyi kapat
			ret
		.endif
		
		.if ax==btnHakkinda				;hakk�nda butonuna bas�ld�ysa
			invoke MessageBox,hWin,ADDR msgHakkinda,ADDR msgBaslik,MB_OK
			ret
		.endif
		.if ax==btnKopyala
			invoke SendMessage,hSerial,EM_SETSEL,0,-1	;seriali se�
			invoke SendMessage,hSerial,WM_COPY,0,0		;seriali panoya kopyala
			invoke SendMessage,hSerial,EM_SETSEL,-1,0	;seriali se�me
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

			invoke GetDlgItemText,hWin,edtAd,addr szName,MAXSIZE;isim bu api ile al�n�yor
			cmp eax,0											;kullan�c� isim girmediyse eax=0
			je _isimyok											;isim yoksa dallan
			
			invoke lstrcat, addr szBuff1, addr szName
			invoke lstrcpy,addr szSerial,chr$('SCTZine-')		;keygene g�re ilk 9 karakter rEdArEnA+ olmal�, szSerial de�i�kenine �nce bunu kopyal�yoruz
			invoke lstrcat,addr szSerial,addr szBuff1			;szSerial ve szBuff1 deki veriler birbirne eklenerek szSeriale yaz�l�yor
			invoke SetDlgItemText,hWin,edtSerial,addr szSerial	;edite seriali yazd�r�yoruz
			_Son:
			xor eax,eax
			ret
			
			_isimyok:
			invoke SetDlgItemText,hWin,edtSerial,chr$('�sim Giriniz!')
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
