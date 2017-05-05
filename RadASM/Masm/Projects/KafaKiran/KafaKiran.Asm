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
; KafaKiran Patcher v1.1.0.1
; _______________________________________________________________________________
; Yazar		: BlueDeviL <blau_devil@hotmail.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.0.5 <www.radasm.com>
; Taslak	: BlueDeviL // SCT
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																	www.sct.tr.cx


.386														;intel 386 instruction seti kullan
.model flat, stdcall										;32bit memory
option casemap :none										;masm büyük küçük hare duyarlı

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
		invoke GetSystemMenu,hWin,FALSE						;sistem menuyü al(minimize maximize falan için)
		mov esi,eax											;dönen değeri esi'ye aktar
		
		;pencerenin ekranı kaplama ve kullanıcının pencereyi boyutlandırmasını önledik
		invoke DeleteMenu,esi, SC_MAXIMIZE,MF_BYCOMMAND		;ekranı kapla menu seçeneğini kaldır
		invoke DeleteMenu,esi, SC_SIZE,MF_BYCOMMAND			;boyutlandırmayı da kaldır
		invoke DrawMenuBar,hWin								;tekrar menu çubuğunu çiz
		
		invoke LoadBitmap,hInstance,5000					;resmimizi yükledik
		invoke LoadIcon,hInstance,5001						;ikonumuzu yükleyelim
		mov hIcon,eax
		invoke SendMessage,hWin,WM_SETICON,NULL,hIcon
		xor eax,eax

	.elseif eax==WM_COMMAND									;Kullanıcı tarafından bir komut mu verildi?
		mov eax,wParam										;dönen değeri eax'e yaz evet hayır 1 veya 0 ;)
		.if eax==btnYAMA									;Patch butonuna mı basıldı?
			invoke YamaIslemi,hWin							;eğer basıldı ise YamaIslemini yapmamk için o prosedüre git
			xor eax,eax
			RET
		.endif
		.if eax==btnHAKKINDA								;eğer hakkında butonuna basılysa hakkında mesaj kutusunu patlat
			invoke MessageBox,hWin,ADDR msgHAKKINDA,ADDR msgBASLIK,MB_OK
		.endif
		;çıkış tuşuna basılında prograımın kapanmasını sağladık:
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
;yama işleminin süreci şöyle olmalı:
;1. Hedef olan yani yamalanacak dosyayi aç (CreateFile fonk.)
;2. Dosya boyutunu al (GetFileSize fonk.)
;3. Hafızada yer ayır.(VirtualAlloc fonk ile)
;4. Dosyayı hafızada oku (ReadFile fonk.)
;5. Önceden değişkenler ile belirlenen baytları  karşılaştır
;6. Belirli olan adreslerdeki baytları değiştirmek için oralara bir pointer var (SetFilePointer)
;7. Yama olan verileri dosyaya yaz(WriteFile)
;8. Yama döngüsünü değişeek bayt sayısı kadar tekrarla
;9. Çıkış
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

;dosyayı açalım
invoke CreateFile, addr DosyaAdi, GENERIC_READ+GENERIC_WRITE, FILE_SHARE_READ,NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
;bu apiden dönen değer hedef dosyamızın handle'ı
mov hDosya, eax
inc eax
test eax,eax
jnz _BoyutuHesapla
invoke MessageBox,NULL,ADDR hataACMA,ADDR hataBASLIK,MB_ICONERROR+MB_OK
jmp _Son


_BoyutuHesapla:
;hedef dosyamızın boyutu hesaplanıyor ve dönen değer bir değişkenen atanıyor
invoke GetFileSize,hDosya,0
mov HafizaBoyutu,eax
inc eax
jne _Hafiza
invoke MessageBox,NULL,ADDR hataBOYUT,ADDR hataBASLIK,MB_ICONERROR+MB_OK
jmp _Son

_Hafiza:
;hedef dosyanın boyutu kadar yeri hafızada ayırıyoruz ve dönen değeri yani
;hafızada ayrılan yerin adresini bir değişkene yazıyoruz
invoke VirtualAlloc,NULL,HafizaBoyutu,MEM_COMMIT,PAGE_READWRITE
mov hHafiza, eax
test eax,eax
jnz _DosyaOku
invoke MessageBox,NULL,ADDR hataHAFIZA,ADDR hataBASLIK,MB_ICONERROR+MB_OK
jmp _Son1

_DosyaOku:
;hafızada ayrılan yere dosyamızı okuyoruz (aslında o adrese hedef dosyayı yazıyoruz)
invoke ReadFile, hDosya, hHafiza, HafizaBoyutu, addr BaytOku, NULL
test eax,eax
jne _DosyaOkundu
invoke MessageBox,NULL,ADDR hataOKUMA,ADDR hataBASLIK,MB_ICONERROR+MB_OK
jmp _Son1


;aşağıda eğer dosyayı okuyabilirsek doğru dosyayı okuyup okuyamadığımızı
;önceden belirlediğimiz orijinal baylar ile karşılaştırarak onaylıyoruz
_DosyaOkundu:
mov ecx,fark				;değişen kaç bayt var? ona göre döngü yap
xor ebx,ebx					;kendimize bir sayaç yazmaç alıyoruz
							;onun için ebx'i 0ladık
_Kontrol1:
mov edi, hHafiza			;edi=dosyayı okumak için hafızada açıtığımız yerin adresi
mov edx, [yamaADRES+ebx*4]	;edx=yamalanacak yerin adresi(burayı döngüye bağladık.
							;böylece tüm adresler sıra ile kontrol edilecek)
add edi,edx					;edi bizim yarattığımız hafıza adresiydi buraya
							;kontrol edeceğimiz ilk hafıza adresini ekliyoruz
lea esi,yamaORIJINAL		;esi=yamalanan orijinal değerlerin adresi
mov al,byte ptr[esi+ebx]	;al=dongu boyunca birer birer orijinal baytları taşı

cmp al,byte ptr[edi]		;al'deki değer ile hedef dosyadan aldığımız değer birbiri ile aynımı?
jne _DosyaBulunamadi
inc ebx
dec ecx
je _YazmaKontrolu
jmp _Kontrol1

_YazmaKontrolu:
mov ebx,sayac
mov edx,[yamaADRES+ebx*4]

invoke SetFilePointer,hDosya,edx,0,0	;bu fonk ile açtığımız dosyanın içine gitmek istediğimiz
										;adrese gidiyoruz, yani değişecek olan yere

inc eax
je _YazmaHatasi
lea esi,yamaDEGISEN			;yama verilerininadresini esiye yazdık

add esi,sayac
;yamalanacak olan adreslere birer bayt olmak üzere yazıyoruz
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
;VirtualAlloc ile hafızaya ayırdığımız sayfayı bu fonk ile salıveriyoruz tabiri caiz ise
invoke VirtualFree,NULL,hHafiza,MEM_DECOMMIT

_Son:
;hDosya bizim hedef dosyamızın handle'ı idi bu fonk ile onu kapatıyoruz
invoke CloseHandle, hDosya

;eax'i sıfırlayıp ret opcode'u ile işlem yaptıktan sonra da penceremizin ekranda kalmasını sağlıyoruz
;istersek bie ExitProcess fonk. ile programı kapatabilirdik. 
xor eax,eax
RET

YamaIslemi ENDP
end start