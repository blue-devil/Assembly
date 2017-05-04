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
; Diyalog Animasyonları 0.1
; _______________________________________________________________________________
; Author	: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.2.0 <radasm.cherrytree.at>
; Template	: BlueDeviL // SCT
; Date		: 03/11/2012
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com
.386					;kullandığımız opcodeların hangi işlemci setine bağlı olduğu
.model flat, stdcall	;32 bit hafıza modeli
option casemap :none	;büyük küçük harfe duyarlı

include AnimateDiyalog.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax
	invoke LoadCursor,NULL,IDC_HAND;linke yükleyeceğimiz imlecin handle'ını al
	mov 	hImlec,eax				;hImlec değişkenine yükle
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
	
	mov eax,hWin
	mov hMain,eax
	push hMain;ana pencerenin handleını yığına atıyoruz, sonra ikinci penceredeyken çağıracağız
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke LoadIcon,hInstance,5001		;ikonumuzu ekledik
											;ancak prog. çalışınca sol üstte ikon yok
											;bunu gidermek için ise:
		mov hIkon,eax
		invoke SendMessage,hWin,WM_SETICON,ICON_SMALL,hIkon;ile pencereye de ikon ekliyoruz
		
		invoke CheckDlgButton,hWin,1004,BST_CHECKED		;ilk açılışta her grubun başındaki
		invoke CheckDlgButton,hWin,1022,BST_CHECKED		;radyobutonları işaretliyoruz
		
		;İmlecYukle işlemini lblLINK ile ilişkilendir
		invoke GetDlgItem,hWin,lblLINK
		push eax
		invoke SetWindowLong,eax,GWL_WNDPROC,ADDR ImlecYukle
		pop edx
		invoke SetWindowLong,edx,GWL_USERDATA,eax
		
	.elseif eax==WM_COMMAND
		mov eax,wParam
		mov edx,wParam
		shr edx,16
		
		.if dx==BN_CLICKED
			.if ax==lblLINK				;web adresimizin olduğu yeremi tıklandı??
				invoke ShellExecute,hWin,ADDR TarayiciyaGit,ADDR SCTweb,NULL,NULL,0
			.endif
		.endif
		.if ax==btnTest					;eğer kullanıcı "Ayarları Dene" tuşuna basarsa
			invoke CloseWindow,hWin		;Ana pencereyi minimize eder
			invoke Sleep,500;ana pencere aşağı insin sonra test penceremiz açılsın arada biraz zaman olsun
			;CreateDialogParam ile yeni penceremizi yaratıyoruz (DialogBoxParam da kullanılabilir)
			invoke CreateDialogParam,hInstance,testpencere,hWin,ADDR TestPenceresi,0
			
			ret
		.endif
		.if ax==btnKapat				;eğer kullanıcı Çıkış tuşuna basarsa
			
			invoke IsDlgButtonChecked,hWin,1014					;Sağdan kaydır
			cmp eax,0
			jz _Sonraki
		    mov ebx,AW_HIDE or AW_SLIDE or AW_HOR_NEGATIVE
			jmp _Son
			_Sonraki:
			invoke IsDlgButtonChecked,hWin,1015					;Soldan Kaydır
			cmp eax,0
			jz _Sonraki0
			mov ebx,AW_HIDE or AW_SLIDE or AW_HOR_POSITIVE
			jmp _Son
			_Sonraki0:
			invoke IsDlgButtonChecked,hWin,1016					;Sağ köşeden sola
			cmp eax,0
			jz _Sonraki1
			mov ebx,AW_HIDE or AW_HOR_NEGATIVE or AW_VER_POSITIVE
			jmp _Son
			_Sonraki1:
			invoke IsDlgButtonChecked,hWin,1017					;Sol köşeden sağa
			cmp eax,0
			jz _Sonraki2
			mov ebx,AW_HIDE or AW_HOR_POSITIVE or AW_VER_POSITIVE
			jmp _Son
			_Sonraki2:
			invoke IsDlgButtonChecked,hWin,1018					;Kaybolarak (Blending ya da fading)
			cmp eax,0
			jz _Sonraki3
			mov ebx,AW_HIDE or AW_BLEND
			jmp _Son
			_Sonraki3:
			invoke IsDlgButtonChecked,hWin,1019					;Merkeze doğru
			cmp eax,0
			jz _Sonraki4
			mov ebx,AW_HIDE or AW_CENTER
			jmp _Son
			_Sonraki4:
			invoke IsDlgButtonChecked,hWin,1020					;Aşağıdan Yukarıya
			cmp eax,0
			jz _Sonraki5
			mov ebx,AW_HIDE or AW_VER_NEGATIVE
			jmp _Son
			_Sonraki5:
			invoke IsDlgButtonChecked,hWin,1021					;Yukarıdan Aşağıya
			cmp eax,0
			jz _Sonraki6
			mov ebx,AW_HIDE or AW_VER_POSITIVE
			jmp _Son
			_Sonraki6:
			invoke IsDlgButtonChecked,hWin,1022					;Sağdan Sola
			cmp eax,0
			jz _Sonraki7
			mov ebx,AW_HIDE or AW_HOR_NEGATIVE
			jmp _Son
			_Sonraki7:
			mov ebx,AW_HIDE or AW_HOR_POSITIVE					;Soldan Sağa
			
			_Son:
			
			invoke AnimateWindow,hWin,600,ebx
			invoke EndDialog,hWin,0								;penceri kapat
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

TestPenceresi proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	
	
	.if uMsg==WM_INITDIALOG
	
		invoke LoadIcon,hInstance,5001		;ikonumuzu ekledik
											;ancak prog. çalışınca sol üstte ikon yok
											;bunu gidermek için ise:
		mov hIkon,eax
		invoke SendMessage,hWin,WM_SETICON,ICON_SMALL,hIkon;ile
		;pencereye de ikon ekliyoruz
		
		;Açılışta Radyo Buton Kontrolü:

			invoke IsDlgButtonChecked,hMain,1013
			cmp eax,0
			jz _Digeri
			mov ebx,AW_ACTIVATE or AW_SLIDE or AW_HOR_NEGATIVE
			jmp _Sonn
			_Digeri:
			invoke IsDlgButtonChecked,hMain,1012
			cmp eax,0
			jz _Digeri0
			mov ebx,AW_ACTIVATE or AW_SLIDE or AW_HOR_POSITIVE
			jmp _Sonn
			_Digeri0:
			invoke IsDlgButtonChecked,hMain,1011
			cmp eax,0
			jz _Digeri1
			mov ebx,AW_ACTIVATE or AW_HOR_NEGATIVE or AW_VER_POSITIVE
			jmp _Sonn
			_Digeri1:
			invoke IsDlgButtonChecked,hMain,1010
			cmp eax,0
			jz _Digeri2
			mov ebx,AW_ACTIVATE or AW_HOR_POSITIVE or AW_VER_POSITIVE
			jmp _Sonn
			_Digeri2:
			invoke IsDlgButtonChecked,hMain,1009
			cmp eax,0
			jz _Digeri3
			mov ebx,AW_ACTIVATE or AW_BLEND
			jmp _Sonn
			_Digeri3:
			invoke IsDlgButtonChecked,hMain,1008
			cmp eax,0
			jz _Digeri4
			mov ebx,AW_ACTIVATE or AW_CENTER
			jmp _Sonn
			_Digeri4:
			invoke IsDlgButtonChecked,hMain,1007
			cmp eax,0
			jz _Digeri5
			mov ebx,AW_ACTIVATE or AW_VER_NEGATIVE
			jmp _Sonn
			_Digeri5:
			invoke IsDlgButtonChecked,hMain,1006
			cmp eax,0
			jz _Digeri6
			mov ebx,AW_ACTIVATE or AW_VER_POSITIVE
			jmp _Sonn
			_Digeri6:
			invoke IsDlgButtonChecked,hMain,1005
			cmp eax,0
			jz _Digeri7
			mov ebx,AW_ACTIVATE or AW_HOR_NEGATIVE
			jmp _Sonn
			_Digeri7:
			mov ebx,AW_ACTIVATE or AW_HOR_POSITIVE
			
			_Sonn:
        	invoke AnimateWindow,hWin,600,ebx
        	invoke SetFocus,hWin
                    
	.elseif uMsg==WM_COMMAND
		mov eax,wParam
		.if eax==btnKKapat				;kullanıcı Kapat butonuna basarsa
			KapanmaKontrolu:
			invoke IsDlgButtonChecked,hMain,1014					
			cmp eax,0
			jz _Sonraki
		    mov ebx,AW_HIDE or AW_SLIDE or AW_HOR_NEGATIVE
			jmp _Son
			_Sonraki:
			invoke IsDlgButtonChecked,hMain,1015				
			cmp eax,0
			jz _Sonraki0
			mov ebx,AW_HIDE or AW_SLIDE or AW_HOR_POSITIVE
			jmp _Son
			_Sonraki0:
			invoke IsDlgButtonChecked,hMain,1016					
			cmp eax,0
			jz _Sonraki1
			mov ebx,AW_HIDE or AW_HOR_NEGATIVE or AW_VER_POSITIVE
			jmp _Son
			_Sonraki1:
			invoke IsDlgButtonChecked,hMain,1017				
			cmp eax,0
			jz _Sonraki2
			mov ebx,AW_HIDE or AW_HOR_POSITIVE or AW_VER_POSITIVE
			jmp _Son
			_Sonraki2:
			invoke IsDlgButtonChecked,hMain,1018				
			cmp eax,0
			jz _Sonraki3
			mov ebx,AW_HIDE or AW_BLEND
			jmp _Son
			_Sonraki3:
			invoke IsDlgButtonChecked,hMain,1019					
			cmp eax,0
			jz _Sonraki4
			mov ebx,AW_HIDE or AW_CENTER
			jmp _Son
			_Sonraki4:
			invoke IsDlgButtonChecked,hMain,1020					
			cmp eax,0
			jz _Sonraki5
			mov ebx,AW_HIDE or AW_VER_NEGATIVE
			jmp _Son
			_Sonraki5:
			invoke IsDlgButtonChecked,hMain,1021					
			cmp eax,0
			jz _Sonraki6
			mov ebx,AW_HIDE or AW_VER_POSITIVE
			jmp _Son
			_Sonraki6:
			invoke IsDlgButtonChecked,hMain,1022				
			cmp eax,0
			jz _Sonraki7
			mov ebx,AW_HIDE or AW_HOR_NEGATIVE
			jmp _Son
			_Sonraki7:
			mov ebx,AW_HIDE or AW_HOR_POSITIVE						
			
			_Son:
			
			invoke AnimateWindow,hWin,600,ebx
			invoke EndDialog,hWin,0								;Test penceremizi kapatıyoruz sonrada
			invoke ShowWindow,hMain,SW_RESTORE					;Ana pencereyi bununla eski haline getiriyoruz
			ret
		.endif
	.elseif uMsg==WM_CLOSE
		;kullanıcı sağ üstteki tuşa basarsa yukarıdaki kapanma kontrolüne dallan
		;Aynı kodu tekrar yazmaya gerek yok değil mi?
		jmp KapanmaKontrolu
	.endif
	xor eax,eax
	ret

TestPenceresi endp

end start
