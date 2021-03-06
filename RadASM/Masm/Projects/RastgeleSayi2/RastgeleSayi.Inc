;fonksiyon tan�m dosyalar�
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include gdi32.inc
include masm32.inc		;nseed ve nrandom i�lemlerinin buradan �a��r�yoruz
include advapi32.inc	;CryptGenRandom() fonksiyonunu kullanmak i�in gerekli
include Irvine32Mb.inc	;Irvine32MB k�t�phanesi:Randomize ve Random32 fonk. kullan�lmas� i�in gerekli
include RandMacro.inc	;Rand() fonksiyonunu �al��t�rmak i�in gerekli(MasmBasic.inc'den buraya ��kartt�m)

;fonksiyonlar�n kendilerinin bulundu�u k�t�phaneler
includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
includelib gdi32.lib
includelib masm32.lib
includelib advapi32.lib
includelib irvine32Mb.lib


;prototipler
DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM;diyalog i�lemi prototipi
ImlecYukle		PROTO	:HWND,:UINT,:WPARAM,:LPARAM;imle�y�kle i�lemi prototipi ile linke imle� y�kl�yoruz
SerialUret		PROTO	:DWORD
RastGele1		PROTO	:DWORD
RastGele2		PROTO	:DWORD
RastGele3		PROTO	:DWORD
RastGele4		PROTO	:DWORD
RastGele5		PROTO	:DWORD
RastGele6		PROTO	:DWORD
RastGele7		PROTO	:DWORD

;sabitler
.const
pencere			equ 101
ikon			equ 5001

edtGTC			equ 1002
edtRDTSC		equ 1003
edtNRANDOM		equ 1012
edtBirOn		equ 1010
btnUret			equ 1006
btnHakkinda		equ 1007
btnCikis		equ 1008
lblLINK			equ 1009
lblBirOn		equ 1005
edtCryptGenRnd	equ 1011
edtIrvine32		equ 1015
edtIrvine322	equ 1017
edtRand			equ 1019



;de�i�kenlerimiz
.data
msgBaslik		db "Hakk�nda",0
msgHakkinda		db "Rastgele Say� �reteci 0.3",13,10,13,10
				db "GetTickCount APIsi kullanarak rastgele say� �retmek:",13,10
				db "Bu API i�letim sisteminin ba�lamas�ndan itibaren ge�en zaman� d�nd�r�r.",13,10
				db "B�ylece her �a�r�ld���nda farkl� bir say�y� eax yazmac�na yazar. Biz de",13,10
				db "bu say�n�n tamam�n� ya da bir k�sm�n� kullanarak rastgele bir say� elde",13,10
				db "ederiz.",13,10,13,10
				db "RDTSC(Time Stamp Counter) kullanarak rastgele say� �retmek:",13,10
				db "Pentium i�lemcilerle beraber gelen bu komut �a�r�ld���nda i�lemcinin",13,10
				db "devrini bize d�nd�r�r.64bit yazma� kullan�r bunun i�in i�in d���k �ncelikli",13,10
				db "32biti EAX yazmac�na y�ksek �ncelikli 32biti EDX yazmac�na yazar.RDTSC bize",13,10
				db "zaman de�il i�lemcinin devrini d�nd�r�r. Ayr�ca ayr�nt�l� bilgi i�in web",13,10
				db "sayfam�za bak�n�z.",13,10,13,10
				db "nrandom Fonksiyonunu kullanarak rastgele say� �retmek:",13,10
				db "MASM32.lib k�t�phanesinde bulunan bir fonksiyondur. MASM kendi i�lemidir.",13,10
				db "H�zl� ve kullan��l�d�r. nseed i�lemi ile de nrandomun her a��l���nda farkl�",13,10
				db "bir say�y� d�nd�rmesini sa�lar�z.",13,10,13,10
				db "CryptGenRandom APIsi kullanarak rastgele say� �retmek:",13,10
				db "advapi32 k�t�phanesindeki bir APIdir.CryptGenRandom APIsi bir de�i�keni",13,10
				db "rastgele baytlar ile doldurur.Bunu yapmak i�inde CryptAcquireContext APIsinden",13,10
				db "d�nen de�eri kullan�r.",13,10,13,10
				db "Irvine32Mb k�t�phanesini kullanarak rastgele say� �retmek:",13,10
				db "Irvine32Mb k�t�phanesindeki Randomize,Random32 ve RandomRange fonksiyonlar� ile",13,10
				db "rastgele say�lar �retilebilir. Randomize her �al��t�rmada rassall�k sa�lar.",13,10
				db "Random32 32bitlik rassal say� �retirken RandomRange belli bir aral�kta �retir.",13,10,13,10
				db "Rand() Fonksiyonu ile rassal say� �retmek(MasmBasic k�t�phanesi):",13,10
				db "Rand() fonksiyonunu MasmBasic.inc k�t�phanesinden ��kartt�m. MasmBasic K�t�p",13,10
				db "hanesini �al��t�rmak i�in ML.EXEnin 6.15 s�r�m�nde ya da hata �st�nde olmas�",13,10
				db "gerekiyor. Bu da baz� makinelerde derleme sorunu yarataca��ndan ben sadece",13,10
				db "Rand() fonksiyonunu ald�m. Parantez i�ine yazaca��n�z say�ya kadar rastgele",13,10
				db "say� �retebilirsiniz.",13,10,13,10
				db "Yazan:",9,"BlueDeviL // SCT",13,10
				db "Tarih:",9,"24.10.2012",13,10
				db "E-Posta:",9,"bluedevil@sctzine.com",13,10,13,10
				db "Te�ekk�rler",13,10
				db "MASM32 forumlar�ndaki arkada�lar, jj2007",13,10
				db "[SCT] 2012",0
				
TarayiciyaGit  	db "open", 0
SCTweb			db "http://www.sctzine.com/",0
format			db "%u",0


;verib�y�kl��� belli olmayan de�i�kenler
.data?

hInstance			dd ?;penceremizin handle'�
hIkon				dd ?;ikonumuzun handle'�
hSerial				dd ?;serialimizin handle'�
hImlec				dd ?;linke y�kledi�imiz imlecin handle'�
hPrv				dd ?;Crypt* APIleri i�in handle

milisaniye			db ?;GetTickCount APIsinden d�nen de�eri buna yazd�r�yoruz
rastsayi			dd ?
rastsayi2			dd ?
rastsayi3			db ?
rastsayi4			dd ?;bir de dw ve db olarak deneyin!
rastsayi5			dd ?
rastsayi6			dd ?
rastsayi7			dd ?
;#########################################################################
