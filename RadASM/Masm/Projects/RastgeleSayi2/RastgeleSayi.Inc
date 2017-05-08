;fonksiyon taným dosyalarý
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include gdi32.inc
include masm32.inc		;nseed ve nrandom iþlemlerinin buradan çaðýrýyoruz
include advapi32.inc	;CryptGenRandom() fonksiyonunu kullanmak için gerekli
include Irvine32Mb.inc	;Irvine32MB kütüphanesi:Randomize ve Random32 fonk. kullanýlmasý için gerekli
include RandMacro.inc	;Rand() fonksiyonunu çalýþtýrmak için gerekli(MasmBasic.inc'den buraya çýkarttým)

;fonksiyonlarýn kendilerinin bulunduðu kütüphaneler
includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
includelib gdi32.lib
includelib masm32.lib
includelib advapi32.lib
includelib irvine32Mb.lib


;prototipler
DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM;diyalog iþlemi prototipi
ImlecYukle		PROTO	:HWND,:UINT,:WPARAM,:LPARAM;imleçyükle iþlemi prototipi ile linke imleç yüklüyoruz
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



;deðiþkenlerimiz
.data
msgBaslik		db "Hakkýnda",0
msgHakkinda		db "Rastgele Sayý Üreteci 0.3",13,10,13,10
				db "GetTickCount APIsi kullanarak rastgele sayý üretmek:",13,10
				db "Bu API iþletim sisteminin baþlamasýndan itibaren geçen zamaný döndürür.",13,10
				db "Böylece her çaðrýldýðýnda farklý bir sayýyý eax yazmacýna yazar. Biz de",13,10
				db "bu sayýnýn tamamýný ya da bir kýsmýný kullanarak rastgele bir sayý elde",13,10
				db "ederiz.",13,10,13,10
				db "RDTSC(Time Stamp Counter) kullanarak rastgele sayý üretmek:",13,10
				db "Pentium iþlemcilerle beraber gelen bu komut çaðrýldýðýnda iþlemcinin",13,10
				db "devrini bize döndürür.64bit yazmaç kullanýr bunun için için düþük öncelikli",13,10
				db "32biti EAX yazmacýna yüksek öncelikli 32biti EDX yazmacýna yazar.RDTSC bize",13,10
				db "zaman deðil iþlemcinin devrini döndürür. Ayrýca ayrýntýlý bilgi için web",13,10
				db "sayfamýza bakýnýz.",13,10,13,10
				db "nrandom Fonksiyonunu kullanarak rastgele sayý üretmek:",13,10
				db "MASM32.lib kütüphanesinde bulunan bir fonksiyondur. MASM kendi iþlemidir.",13,10
				db "Hýzlý ve kullanýþlýdýr. nseed iþlemi ile de nrandomun her açýlýþýnda farklý",13,10
				db "bir sayýyý döndürmesini saðlarýz.",13,10,13,10
				db "CryptGenRandom APIsi kullanarak rastgele sayý üretmek:",13,10
				db "advapi32 kütüphanesindeki bir APIdir.CryptGenRandom APIsi bir deðiþkeni",13,10
				db "rastgele baytlar ile doldurur.Bunu yapmak içinde CryptAcquireContext APIsinden",13,10
				db "dönen deðeri kullanýr.",13,10,13,10
				db "Irvine32Mb kütüphanesini kullanarak rastgele sayý üretmek:",13,10
				db "Irvine32Mb kütüphanesindeki Randomize,Random32 ve RandomRange fonksiyonlarý ile",13,10
				db "rastgele sayýlar üretilebilir. Randomize her çalýþtýrmada rassallýk saðlar.",13,10
				db "Random32 32bitlik rassal sayý üretirken RandomRange belli bir aralýkta üretir.",13,10,13,10
				db "Rand() Fonksiyonu ile rassal sayý üretmek(MasmBasic kütüphanesi):",13,10
				db "Rand() fonksiyonunu MasmBasic.inc kütüphanesinden çýkarttým. MasmBasic Kütüp",13,10
				db "hanesini çalýþtýrmak için ML.EXEnin 6.15 sürümünde ya da hata üstünde olmasý",13,10
				db "gerekiyor. Bu da bazý makinelerde derleme sorunu yaratacaðýndan ben sadece",13,10
				db "Rand() fonksiyonunu aldým. Parantez içine yazacaðýnýz sayýya kadar rastgele",13,10
				db "sayý üretebilirsiniz.",13,10,13,10
				db "Yazan:",9,"BlueDeviL // SCT",13,10
				db "Tarih:",9,"24.10.2012",13,10
				db "E-Posta:",9,"bluedevil@sctzine.com",13,10,13,10
				db "Teþekkürler",13,10
				db "MASM32 forumlarýndaki arkadaþlar, jj2007",13,10
				db "[SCT] 2012",0
				
TarayiciyaGit  	db "open", 0
SCTweb			db "http://www.sctzine.com/",0
format			db "%u",0


;veribüyüklüðü belli olmayan deðiþkenler
.data?

hInstance			dd ?;penceremizin handle'ý
hIkon				dd ?;ikonumuzun handle'ý
hSerial				dd ?;serialimizin handle'ý
hImlec				dd ?;linke yüklediðimiz imlecin handle'ý
hPrv				dd ?;Crypt* APIleri için handle

milisaniye			db ?;GetTickCount APIsinden dönen deðeri buna yazdýrýyoruz
rastsayi			dd ?
rastsayi2			dd ?
rastsayi3			db ?
rastsayi4			dd ?;bir de dw ve db olarak deneyin!
rastsayi5			dd ?
rastsayi6			dd ?
rastsayi7			dd ?
;#########################################################################
