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
; Random Real Number Generator
; _______________________________________________________________________________
; Author	: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.2.0 <radasm.cherrytree.at>
; Template	: BlueDeviL // SCT
; Date		: 04/08/2012
; �������������������������������������������������������������������������������
;																  www.sctzine.com
.586					;kulland���m�z opcodelar�n hangi i�lemci setine ba�l� oldu�u
.model flat, stdcall	;32 bit haf�za modeli
option casemap :none	;b�y�k k���k harfe duyarl�

include RastgeleRealSayi.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax
	invoke LoadCursor,NULL,IDC_HAND;linke y�kleyece�imiz imlecin handle'�n� al
	mov hImlec,eax
    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,pencere,NULL,addr PencereIslemi,NULL
	invoke ExitProcess,0
	
	
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

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke LoadIcon,hInstance,5001		;ikonumuzu ekledik
											;ancak prog. �al���nca sol �stte ikon yok
											;bunu gidermek i�in ise:
		mov hIkon,eax
		invoke SendMessage,hWin,WM_SETICON,ICON_SMALL,hIkon;ile
		;pencereye de ikon ekliyoruz
		
		;Liste kutular�m�z�n handlelar�n� al�yoruz
		invoke GetDlgItem,hWin,lst0dan1e
		mov hListeKutusu,eax
		invoke GetDlgItem,hWin,lst1den10a
		mov hListeKutusu2,eax
		invoke RassalReelUret,hWin				;sonra da rassal reel �ret

		;�mlecYukle i�lemini lblLINK ile ili�kilendir
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
			.if ax==lblLINK				;web adresimizin oldu�u yeremi t�kland�??
				invoke ShellExecute,hWin,ADDR TarayiciyaGit,ADDR SCTweb,NULL,NULL,0
			.endif
		.endif
		
		.if ax==btnUret					;kullanc� �ret tu�una m� bast�?
			invoke RassalReelUret,hWin	;rassal reel �ret
		.endif
		.if ax==btnKapat				;e�er kullan�c� ��k�� tu�una basarsa
			invoke EndDialog,hWin,0		;pencereyi kapat
			ret
		.endif
		
		.if ax==btnHakkinda				;hakk�nda butonuna bas�ld�ysa
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
;generate =)
	
	invoke Rastgele01,NULL				;generate random between 0-1
	invoke Rastgele110,NULL				;generate random between 1-10
	xor eax,eax
	ret

RassalReelUret endp

Rastgele01	PROC uses ebx edi esi,hWin:DWORD
;this procedure generates random real between 0-1

	RDTSC								;time stamp counter
	invoke nseed,eax					;every time program executes 
										;nseed provides nrandom to generate different values
	_tekrar:	
	invoke nrandom,100d					;generate random between 0-99
	cmp eax,0
	jz _tekrar
	mov DWORD PTR DS:[tampon],eax
	finit
	fldpi								;load number pi to ST, but you can also use constant 'e' : "fldl2e"
	fimul DWORD PTR DS:[tampon]
	fidiv DWORD PTR DS:[tampon2]

	invoke FpuFLtoA,0,8,addr rastsayi,SRC1_FPU	;FpuFLtoA function converts an 80-bit REAL number to its alphanumeric decimal 
												;representation (either in decimal format or scientific notation) and returns 
												;the result as a null-terminated string at the specified destination.
												;if u change the number 8 to 4 function return 4 numbers after dot '0.xxxx'.
	invoke SendMessage,hListeKutusu,LB_ADDSTRING,0,addr rastsayi;write to list
	ret

Rastgele01 endp

Rastgele110	PROC	uses ebx edi esi,hWin:DWORD
;this procedure generates random real between 1-10

	RDTSC								;time stamp counter
	invoke nseed,eax					;program her ba�lad���nda nrandomun farkl� 
										;say�larla a��lmas�n� sa�lar
	_tekrar:	
	invoke nrandom,100d					;0-99 aras�nda rassal say� �retir 
	cmp eax,0
	jz _tekrar
	mov DWORD PTR DS:[tampon],eax
	finit
	fldpi								;pi say�s� yerine sabit e say�s� da kullan�labilir: "fldl2e" komutu ile
	fimul DWORD PTR DS:[tampon]
	fidiv DWORD PTR DS:[tampon2]

	_tekrar2:	
	invoke nrandom,10d					;0-9 aras�nda rassal say� �retir 
	cmp eax,0
	jz _tekrar2
	mov DWORD PTR DS:[tampon],eax
	fiadd DWORD PTR DS:[tampon]			;add a number between 1-9(both included)

	invoke FpuFLtoA,0,8,addr rastsayi,SRC1_FPU	;reel say�y� nktas�yla birlikte string olarak d�nd�r�r
												;e�er 8 yerine 4 yazarsan�z noktadan sonraki 4 haneyi d�nd�r�r.
	invoke SendMessage,hListeKutusu2,LB_ADDSTRING,0,addr rastsayi;listeye yaz
	ret

Rastgele110 endp
end start
