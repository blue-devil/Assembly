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
; Rastgele Say� �reteci v0.2
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.2.0 <radasm.cherrytree.at>
; Taslak	: BlueDeviL // SCT
; Tarih		: 24/10/2012
; �������������������������������������������������������������������������������
;																  www.sctzine.com
.586					;kulland���m�z opcodelar�n hangi i�lemci setine ba�l� oldu�u
						;normalde 386 kullan�r�m ben ama rastgele say� �retmek i�in 
						;kulland���m RDTSC fonksiyonu en az .586 i�lemci komut setinde
						;bulunuyor.
						;.xmm
.model flat, stdcall	;32 bit haf�za modeli
option casemap :none	;b�y�k k���k harfe duyarl�

include RastgeleSayi.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax
	invoke LoadCursor,NULL,IDC_HAND;linke y�kleyece�imiz imlecin handle'�n� al
	mov hImlec,eax
    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,pencere,NULL,addr DlgProc,NULL
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

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke LoadIcon,hInstance,5001	;ikonumuzu ekledik
										;ancak prog. �al���nca sol �stte ikon yok
										;bunu gidermek i�in ise:
		mov hIkon,eax
		invoke SendMessage,hWin,WM_SETICON,ICON_SMALL,hIkon;ile
		;pencereye de ikon ekliyoruz
		
		
		invoke SerialUret,hWin;sonrada seriali o isme g�re �retsin
		
		;�mlecYukle i�lemini lblLINK ile ili�kilendir
		invoke GetDlgItem,hWin,lblLINK
		push eax
		invoke SetWindowLong,eax,GWL_WNDPROC,ADDR ImlecYukle
		pop edx
		invoke SetWindowLong,edx,GWL_USERDATA,eax
		
		;Men� butonlar�n� silmek istiyorum
		;Bu sebeple �nce men�n�n handle'�n� al�yorum
		;daha sonra istedi�im men� tu�lar�n� silece�im
		;WM_SYSCOMMAND --> win32.hlp den inceleyin
		invoke GetSystemMenu,hWin,FALSE
		mov esi,eax
		invoke DeleteMenu,esi,SC_RESTORE,MF_BYCOMMAND;�nceki boyut iptal
		invoke DeleteMenu,esi,SC_MAXIMIZE,MF_BYCOMMAND;ekran� kapla iptal
		invoke DeleteMenu,esi,SC_SIZE,MF_BYCOMMAND;boyut iptal

	.elseif eax==WM_COMMAND
		mov eax,wParam
		mov edx,wParam
		shr edx,16
		
		.if dx==BN_CLICKED
			.if ax==lblLINK;web adresimizin oldu�u yeremi t�kland�??
				invoke ShellExecute,hWin,ADDR TarayiciyaGit,ADDR SCTweb,NULL,NULL,0
			.endif
		.endif
		
		.if ax==btnUret					;kullanc� �ret tu�una m� bast�?
			invoke SerialUret,hWin
		.endif
		.if ax==btnCikis				;e�er kullan�c� ��k�� tu�una basarsa
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
	;GetTickCount ile windowsun ba�lad��� zamandan itibaren ge�en s�reyi
	;hesaplay�p milisaniye de�i�kenine yazd�k.
	;milisaniye de�i�kenini bayt olarak tan�mlad�k b�ylece alabilece�i
	;de�erleri k�s�tlad�k:"0 - 255"
	;siz bu de�i�keni word(ax) yada dword(eax) olarak tan�mlay�p k�s�t
	;aral���n� geni�letebilirsiniz.
	
	;ya da api ile elde etti�iniz bu rassal say�y� yazaca��n�z k���k-b�y�k
	;bir fonksiyona sokarak sadece belirli bir aral��a ait say�lar� rassal olarak g�sterebilir.
	;veya sizin istedi�iniz �ekilde olan bir rassal say� fonksiyonu ekleyebilirsiniz
	;______________________________________________________________________________
	;1-10 aras�ndaki say�lar� rassal olarak yazd�rmak:
	;Sadece birden 10'a kadar olan say�lar� rassal olarak yazd�rmak
	;son derece basit: AL de�erini bir de�i�kene yazd�r�p
	;1 ile 10 aras�nda olup olmamas�n� kontrol ettiriyoruz:
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
	;RDTSC i�lemcinin en son resetlenmesinden itibaren ge�en s�reyi
	;�a�r�ld���nda milisaniye olarak d�nd�r�r.
	;RDTSC 586 i�lemci komut setinden itibaren assembly diline ge�mi�tir.
	;388 ya da 486 da yoktur dikkaetinize!!!!
	;A�a��da sadece RDTSC'den d�nen de�eri yazd�r�yorum ayr�ca ba�ka bir i�lem yapt�rm�yorum
	RDTSC			;Time Stamp Counter
	mov rastsayi,eax
	ret

RastGele2 endp

RastGele3 PROC tampon3:DWORD
	
	RDTSC
	invoke nseed,eax	;program her ba�lad���nda nrandomun farkl� 
						;say�larla a��lmas�n� sa�lar
	invoke nrandom,100d	;0-99 aras�nda rassal say� �retir 
	mov rastsayi2,eax
	ret

RastGele3 endp

RastGele4 PROC tampon4:DWORD
	
	;CryptAcquireContext APIsi, bizim belitti�imiz cryptographic service provider (CSP) i�inden
	;bir handle de�eri elde eder. Bu handle ile se�ilen CSP kullan�lacak di�er APIler i�in �a�r�l�r.
	;Bunun �rne�i a�a��daki CryptGenRandom APIsidir.
	invoke CryptAcquireContext,offset hPrv,0,0,PROV_RSA_FULL,CRYPT_VERIFYCONTEXT + CRYPT_SILENT
	
	;CryptGenRandom APIsi bir de�i�keni rastgele baytlar ile doldurur. Bunu yapmak i�inde 
	;CryptAcquireContext APIsinden d�nen de�eri kullan�r.
	
	;CryptAcquireContext APIsini kald�rarak program� tekrar derleyin. CryptGenRandom APIsi
	;yine say� �retecektir. Ancak bu sefer stabil �ekilde rastgele say�lar �retmeyecektir.
	
	;-->hPrv handle'�  cryptographic service provider (CSP)'� i�aret eder ve bu say�
	;CryptAcquireContext taraf�ndan �retilir.
	invoke CryptGenRandom,hPrv,10,addr rastsayi4
	
	;Her iki APIyi de Win32.hlp dosyas�ndan ya da MSDN k�t�phanesinden ara�t�rabilirsiniz.
	ret

RastGele4 endp

RastGele5 PROC tampon5:DWORD
	
	;kernel32 i�inde bulunan bu API y�ksek ��z�n�rl�kl� performans sayac�n�n de�erini d�nd�r�r
	;tabi e�er varsa. D�nd�rd��� say� tampona yaz�l�r. 
	;e�er ba�ar�l� olursa eax'e d�nen de�er 0 ama hata varsa d�nen de�er 1 olur!
	;mov rastsayi5,0
	invoke Randomize
	invoke Random32
	mov rastsayi5,eax
	ret

RastGele5 endp

RastGele6 PROC tampon6:DWORD
	
	invoke Randomize
	mov eax,99d			;bize aral���n �st s�n�r�n� verir
	invoke RandomRange	;Bu fonksiyon bir aral�k aras�ndan rastgele say� �retmeye yarar.
						;Aral���n �st s�n�r�n� eaxe yazar�z. D�nen sonu� gene eaxe yaz�l�r.
						;e�er bir alt limit belitmek istiyorsak:
						;�st limitten alt limiti ��kart�p fonksiyonu �a��r�r�z, d�nen sonuca alt limiti ekleriz =)
	mov rastsayi6,eax
	ret

RastGele6 endp
RastGele7 PROC tampon7:DWORD
	
	mov eax,Rand(1071)	;Rand() fonksiyonu MasmBasic.inc doyas�ndan ��kartt�m.
						;orjinalinde fonksiyon MasmBasic k�t�phanesinin bir fonksiyonu. Ancak MasmBasic k�t�p.
						;�al��t�rmak i�in ya JWasm kurulu olmal� ya da ML.EXE 6.15 veya daha y�ksek s�r�mde olmal�
						;Baz� bilgisayarlarda hata olaca�� i�in bu �ekilde yapt�m
						;Parantez i�indeki rakam ondal�k tabanda rassal say� �retiminin �st s�n�r�d�r.
						;http://www.webalice.it/jj2006/MasmBasicQuickReference.htm#Mb1029
	mov rastsayi7,eax
	ret

RastGele7 endp
end start
