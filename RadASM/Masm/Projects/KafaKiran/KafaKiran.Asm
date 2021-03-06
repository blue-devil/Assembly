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
; KafaKiran Patcher v1.1.0.1
; _______________________________________________________________________________
; Yazar		: BlueDeviL <blau_devil@hotmail.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.0.5 <www.radasm.com>
; Taslak	: BlueDeviL // SCT
; �������������������������������������������������������������������������������
;																	www.sct.tr.cx


.386														;intel 386 instruction seti kullan
.model flat, stdcall										;32bit memory
option casemap :none										;masm b�y�k k���k hare duyarl�

include KafaKiran.inc										;

.code
start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,dialogANA,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke GetSystemMenu,hWin,FALSE						;sistem menuy� al(minimize maximize falan i�in)
		mov esi,eax											;d�nen de�eri esi'ye aktar
		
		;pencerenin ekran� kaplama ve kullan�c�n�n pencereyi boyutland�rmas�n� �nledik
		invoke DeleteMenu,esi, SC_MAXIMIZE,MF_BYCOMMAND		;ekran� kapla menu se�ene�ini kald�r
		invoke DeleteMenu,esi, SC_SIZE,MF_BYCOMMAND			;boyutland�rmay� da kald�r
		invoke DrawMenuBar,hWin								;tekrar menu �ubu�unu �iz
		
		invoke LoadBitmap,hInstance,5000					;resmimizi y�kledik
		invoke LoadIcon,hInstance,5001						;ikonumuzu y�kleyelim
		mov hIcon,eax
		invoke SendMessage,hWin,WM_SETICON,NULL,hIcon
		xor eax,eax

	.elseif eax==WM_COMMAND									;Kullan�c� taraf�ndan bir komut mu verildi?
		mov eax,wParam										;d�nen de�eri eax'e yaz evet hay�r 1 veya 0 ;)
		.if eax==btnYAMA									;Patch butonuna m� bas�ld�?
			invoke YamaIslemi,hWin							;e�er bas�ld� ise YamaIslemini yapmamk i�in o prosed�re git
			xor eax,eax
			RET
		.endif
		.if eax==btnHAKKINDA								;e�er hakk�nda butonuna bas�lysa hakk�nda mesaj kutusunu patlat
			invoke MessageBox,hWin,ADDR msgHAKKINDA,ADDR msgBASLIK,MB_OK
		.endif
		;��k�� tu�una bas�l�nda progra�m�n kapanmas�n� sa�lad�k:
		.if eax==btnCIKIS
			invoke EndDialog,hWin,0
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

YamaIslemi PROC hWin:DWORD

; ___________________________________________________________
;yama i�leminin s�reci ��yle olmal�:
;1. Hedef olan yani yamalanacak dosyayi a� (CreateFile fonk.)
;2. Dosya boyutunu al (GetFileSize fonk.)
;3. Haf�zada yer ay�r.(VirtualAlloc fonk ile)
;4. Dosyay� haf�zada oku (ReadFile fonk.)
;5. �nceden de�i�kenler ile belirlenen baytlar�  kar��la�t�r
;6. Belirli olan adreslerdeki baytlar� de�i�tirmek i�in oralara bir pointer var (SetFilePointer)
;7. Yama olan verileri dosyaya yaz(WriteFile)
;8. Yama d�ng�s�n� de�i�eek bayt say�s� kadar tekrarla
;9. ��k��
; �����������������������������������������������������������

;dosyay� a�al�m
invoke CreateFile, addr DosyaAdi, GENERIC_READ+GENERIC_WRITE, FILE_SHARE_READ,NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
;bu apiden d�nen de�er hedef dosyam�z�n handle'�
mov hDosya, eax
inc eax
test eax,eax
jnz _BoyutuHesapla
invoke MessageBox,NULL,ADDR hataACMA,ADDR hataBASLIK,MB_ICONERROR+MB_OK
jmp _Son


_BoyutuHesapla:
;hedef dosyam�z�n boyutu hesaplan�yor ve d�nen de�er bir de�i�kenen atan�yor
invoke GetFileSize,hDosya,0
mov HafizaBoyutu,eax
inc eax
jne _Hafiza
invoke MessageBox,NULL,ADDR hataBOYUT,ADDR hataBASLIK,MB_ICONERROR+MB_OK
jmp _Son

_Hafiza:
;hedef dosyan�n boyutu kadar yeri haf�zada ay�r�yoruz ve d�nen de�eri yani
;haf�zada ayr�lan yerin adresini bir de�i�kene yaz�yoruz
invoke VirtualAlloc,NULL,HafizaBoyutu,MEM_COMMIT,PAGE_READWRITE
mov hHafiza, eax
test eax,eax
jnz _DosyaOku
invoke MessageBox,NULL,ADDR hataHAFIZA,ADDR hataBASLIK,MB_ICONERROR+MB_OK
jmp _Son1

_DosyaOku:
;haf�zada ayr�lan yere dosyam�z� okuyoruz (asl�nda o adrese hedef dosyay� yaz�yoruz)
invoke ReadFile, hDosya, hHafiza, HafizaBoyutu, addr BaytOku, NULL
test eax,eax
jne _DosyaOkundu
invoke MessageBox,NULL,ADDR hataOKUMA,ADDR hataBASLIK,MB_ICONERROR+MB_OK
jmp _Son1


;a�a��da e�er dosyay� okuyabilirsek do�ru dosyay� okuyup okuyamad���m�z�
;�nceden belirledi�imiz orijinal baylar ile kar��la�t�rarak onayl�yoruz
_DosyaOkundu:
mov ecx,fark				;de�i�en ka� bayt var? ona g�re d�ng� yap
xor ebx,ebx					;kendimize bir saya� yazma� al�yoruz
							;onun i�in ebx'i 0lad�k
_Kontrol1:
mov edi, hHafiza			;edi=dosyay� okumak i�in haf�zada a��t���m�z yerin adresi
mov edx, [yamaADRES+ebx*4]	;edx=yamalanacak yerin adresi(buray� d�ng�ye ba�lad�k.
							;b�ylece t�m adresler s�ra ile kontrol edilecek)
add edi,edx					;edi bizim yaratt���m�z haf�za adresiydi buraya
							;kontrol edece�imiz ilk haf�za adresini ekliyoruz
lea esi,yamaORIJINAL		;esi=yamalanan orijinal de�erlerin adresi
mov al,byte ptr[esi+ebx]	;al=dongu boyunca birer birer orijinal baytlar� ta��

cmp al,byte ptr[edi]		;al'deki de�er ile hedef dosyadan ald���m�z de�er birbiri ile ayn�m�?
jne _DosyaBulunamadi
inc ebx
dec ecx
je _YazmaKontrolu
jmp _Kontrol1

_YazmaKontrolu:
mov ebx,sayac
mov edx,[yamaADRES+ebx*4]

invoke SetFilePointer,hDosya,edx,0,0	;bu fonk ile a�t���m�z dosyan�n i�ine gitmek istedi�imiz
										;adrese gidiyoruz, yani de�i�ecek olan yere

inc eax
je _YazmaHatasi
lea esi,yamaDEGISEN			;yama verilerininadresini esiye yazd�k

add esi,sayac
;yamalanacak olan adreslere birer bayt olmak �zere yaz�yoruz
invoke WriteFile,hDosya,esi,1,offset BaytYaz,NULL
test eax,eax
je _YazmaHatasi
inc sayac
mov ebx,sayac
sub ebx,fark
jne _YazmaKontrolu

invoke MessageBox,NULL,ADDR hzrMETIN,ADDR hzrBASLIK,MB_ICONASTERISK+MB_OK
jmp _Son1



_YazmaHatasi:
invoke MessageBox,NULL,ADDR hataYAZMA,ADDR hataBASLIK,MB_ICONERROR+MB_OK
jmp _Son1

_DosyaBulunamadi:
invoke MessageBox,NULL,ADDR hataBAYT,ADDR hataBASLIK,MB_ICONERROR+MB_OK

_Son1:
;VirtualAlloc ile haf�zaya ay�rd���m�z sayfay� bu fonk ile sal�veriyoruz tabiri caiz ise
invoke VirtualFree,NULL,hHafiza,MEM_DECOMMIT

_Son:
;hDosya bizim hedef dosyam�z�n handle'� idi bu fonk ile onu kapat�yoruz
invoke CloseHandle, hDosya

;eax'i s�f�rlay�p ret opcode'u ile i�lem yapt�ktan sonra da penceremizin ekranda kalmas�n� sa�l�yoruz
;istersek bie ExitProcess fonk. ile program� kapatabilirdik. 
xor eax,eax
RET

YamaIslemi ENDP
end start