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
; Rastgele Sayı Üreteci v0.2
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.2.0 <radasm.cherrytree.at>
; Taslak	: BlueDeviL // SCT
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
invoke SetDlgItemText,hWin,edtGTC,addr milisaniye
invoke wsprintf,addr rastsayi3,addr format,rastsayi3
invoke SetDlgItemText,hWin,edtBirOn,addr rastsayi3

invoke RastGele2,NULL
invoke wsprintf,addr rastsayi,addr format,rastsayi
invoke SetDlgItemText,hWin,edtRDTSC,addr rastsayi

invoke RastGele3,NULL
invoke wsprintf,addr rastsayi2,addr format,rastsayi2
invoke SetDlgItemText,hWin,edtNRANDOM,addr rastsayi2

invoke RastGele4,NULL
invoke wsprintf,addr rastsayi4,addr format,rastsayi4
invoke SetDlgItemText,hWin,edtCryptGenRnd,addr rastsayi4

invoke RastGele5,NULL
invoke wsprintf,addr rastsayi5,addr format,rastsayi5
invoke SetDlgItemText,hWin,edtIrvine32,addr rastsayi5

invoke RastGele6,NULL
invoke wsprintf,addr rastsayi6,addr format,rastsayi6
invoke SetDlgItemText,hWin,edtIrvine322,addr rastsayi6

invoke RastGele7,NULL
invoke wsprintf,addr rastsayi7,addr format,rastsayi7
invoke SetDlgItemText,hWin,edtRand,addr rastsayi7

_Son:
xor eax,eax
ret

SerialUret endp

RastGele1	PROC	tampon1:DWORD
	invoke GetTickCount
	mov milisaniye,al
	;GetTickCount ile windowsun başladığı zamandan itibaren geçen süreyi
	;hesaplayıp milisaniye değişkenine yazdık.
	;milisaniye değişkenini bayt olarak tanımladık böylece alabileceği
	;değerleri kısıtladık:"0 - 255"
	;siz bu değişkeni word(ax) yada dword(eax) olarak tanımlayıp kısıt
	;aralığını genişletebilirsiniz.
	
	;ya da api ile elde ettiğiniz bu rassal sayıyı yazacağınız küçük-büyük
	;bir fonksiyona sokarak sadece belirli bir aralığa ait sayıları rassal olarak gösterebilir.
	;veya sizin istediğiniz şekilde olan bir rassal sayı fonksiyonu ekleyebilirsiniz
	;______________________________________________________________________________
	;1-10 arasındaki sayıları rassal olarak yazdırmak:
	;Sadece birden 10'a kadar olan sayıları rassal olarak yazdırmak
	;son derece basit: AL değerini bir değişkene yazdırıp
	;1 ile 10 arasında olup olmamasını kontrol ettiriyoruz:
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
	;RDTSC işlemcinin en son resetlenmesinden itibaren geçen süreyi
	;çağrıldığında milisaniye olarak döndürür.
	;RDTSC 586 işlemci komut setinden itibaren assembly diline geçmiştir.
	;388 ya da 486 da yoktur dikkaetinize!!!!
	;Aşağıda sadece RDTSC'den dönen değeri yazdırıyorum ayrıca başka bir işlem yaptırmıyorum
	RDTSC			;Time Stamp Counter
	mov rastsayi,eax
	ret

RastGele2 endp

RastGele3 PROC tampon3:DWORD
	
	RDTSC
	invoke nseed,eax	;program her başladığında nrandomun farklı 
						;sayılarla açılmasını sağlar
	invoke nrandom,100d	;0-99 arasında rassal sayı üretir 
	mov rastsayi2,eax
	ret

RastGele3 endp

RastGele4 PROC tampon4:DWORD
	
	;CryptAcquireContext APIsi, bizim belittiğimiz cryptographic service provider (CSP) içinden
	;bir handle değeri elde eder. Bu handle ile seçilen CSP kullanılacak diğer APIler için çağrılır.
	;Bunun örneği aşağıdaki CryptGenRandom APIsidir.
	invoke CryptAcquireContext,offset hPrv,0,0,PROV_RSA_FULL,CRYPT_VERIFYCONTEXT + CRYPT_SILENT
	
	;CryptGenRandom APIsi bir değişkeni rastgele baytlar ile doldurur. Bunu yapmak içinde 
	;CryptAcquireContext APIsinden dönen değeri kullanır.
	
	;CryptAcquireContext APIsini kaldırarak programı tekrar derleyin. CryptGenRandom APIsi
	;yine sayı üretecektir. Ancak bu sefer stabil şekilde rastgele sayılar üretmeyecektir.
	
	;-->hPrv handle'ı  cryptographic service provider (CSP)'ı işaret eder ve bu sayı
	;CryptAcquireContext tarafından üretilir.
	invoke CryptGenRandom,hPrv,10,addr rastsayi4
	
	;Her iki APIyi de Win32.hlp dosyasından ya da MSDN kütüphanesinden araştırabilirsiniz.
	ret

RastGele4 endp

RastGele5 PROC tampon5:DWORD
	
	;kernel32 içinde bulunan bu API yüksek çözünürlüklü performans sayacının değerini döndürür
	;tabi eğer varsa. Döndürdüğü sayı tampona yazılır. 
	;eğer başarılı olursa eax'e dönen değer 0 ama hata varsa dönen değer 1 olur!
	;mov rastsayi5,0
	invoke Randomize
	invoke Random32
	mov rastsayi5,eax
	ret

RastGele5 endp

RastGele6 PROC tampon6:DWORD
	
	invoke Randomize
	mov eax,99d			;bize aralığın üst sınırını verir
	invoke RandomRange	;Bu fonksiyon bir aralık arasından rastgele sayı üretmeye yarar.
						;Aralığın üst sınırını eaxe yazarız. Dönen sonuç gene eaxe yazılır.
						;eğer bir alt limit belitmek istiyorsak:
						;üst limitten alt limiti çıkartıp fonksiyonu çağırırız, dönen sonuca alt limiti ekleriz =)
	mov rastsayi6,eax
	ret

RastGele6 endp
RastGele7 PROC tampon7:DWORD
	
	mov eax,Rand(1071)	;Rand() fonksiyonu MasmBasic.inc doyasından çıkarttım.
						;orjinalinde fonksiyon MasmBasic kütüphanesinin bir fonksiyonu. Ancak MasmBasic kütüp.
						;çalıştırmak için ya JWasm kurulu olmalı ya da ML.EXE 6.15 veya daha yüksek sürümde olmalı
						;Bazı bilgisayarlarda hata olacağı için bu şekilde yaptım
						;Parantez içindeki rakam ondalık tabanda rassal sayı üretiminin üst sınırıdır.
						;http://www.webalice.it/jj2006/MasmBasicQuickReference.htm#Mb1029
	mov rastsayi7,eax
	ret

RastGele7 endp
end start
