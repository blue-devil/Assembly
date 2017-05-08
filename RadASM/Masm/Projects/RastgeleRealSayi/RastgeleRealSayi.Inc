;fonksiyon taným dosyalarý
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include gdi32.inc
include masm32.inc		;nseed ve nrandom iþlemlerinin buradan çaðýrýyoruz
include fpu.inc
include uxtheme.inc


;fonksiyonlarýn kendilerinin bulunduðu kütüphaneler
includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
includelib gdi32.lib
includelib masm32.lib
includelib fpu.lib
includelib uxtheme.lib


;prototipler
PencereIslemi	PROTO	:HWND,:UINT,:WPARAM,:LPARAM;diyalog iþlemi prototipi
ImlecYukle		PROTO	:HWND,:UINT,:WPARAM,:LPARAM;imleçyükle iþlemi prototipi ile linke imleç yüklüyoruz
RassalReelUret	PROTO	:DWORD
Rastgele01		PROTO	:DWORD
Rastgele110		PROTO	:DWORD

;sabitler
.const
pencere			equ 101
ikon			equ 5001

lst0dan1e		equ 1003
lst1den10a		equ 1004
btnKapat		equ 1005
btnHakkinda		equ 1006
btnUret			equ 1007
lblLINK			equ 1008

;deðiþkenlerimiz
.data
msgBaslik		db "Hakkýnda",0
msgHakkinda		db "Rastgele Reel Sayý Üreteci",13,10,13,10
				db "RDTSC(Time Stamp Counter) kullanarak rastgele sayý üretmek:",13,10,13,10
				db "Pentium iþlemcilerle beraber gelen bu komut çaðrýldýðýnda iþlemcinin",13,10
				db "devrini bize döndürür.64bit yazmaç kullanýr bunun için için düþük öncelikli",13,10
				db "32biti EAX yazmacýna yüksek öncelikli 32biti EDX yazmacýna yazar.RDTSC bize",13,10
				db "zaman deðil iþlemcinin devrini döndürür. Ayrýca ayrýntýlý bilgi için web",13,10
				db "sayfamýza bakýnýz.",13,10,13,10
				db "nrandom Fonksiyonunu kullanarak rastgele sayý üretmek:",13,10,13,10
				db "MASM32.lib kütüphanesinde bulunan bir fonksiyondur. MASM kendi iþlemidir.",13,10
				db "Hýzlý ve kullanýþlýdýr. nseed iþlemi ile de nrandomun her açýlýþýnda farklý",13,10
				db "bir sayýyý döndürmesini saðlarýz.",13,10,13,10
				db "FPU komutlarý:",13,10,13,10
				db "RDTSC ve nrandom ile ürettiðimiz tamsayý rassal sayýyý",13,10
				db "pi sayýsý ile çarparak reel hale getiryoruz.FPU komutlarýndan",13,10
				db "fldpi pi sayýsýný döndürür.fldl2e komutu ise e sabitini döndürür.",13,10
				db "Bu ikisini kullanmak zorunda deðilsiniz, bir deðiþkene reel bir sayý",13,10
				db "atayarakda kendi rassal sayý fonksiyonunuzu oluþturabilirsiniz.",13,10
				db "FPU için ayrýntýlý bilgi için Raymond Filiatreault tarafýndan hazýrlanmýþ",13,10
				db "bir að sayfasý var orayý ziyaret ediniz.",13,10,13,10
				db "Yazan:",9,"BlueDeviL // SCT",13,10
				db "Tarih:",9,"04.08.2012",13,10
				db "E-Posta:",9,"bluedevil@sctzine.com",13,10,13,10
				db "Teþekkürler",13,10
				db "MASM32 Forumlarý,Emektar bilgisayarým",13,10
				db "[SCT] 2012",0
				
TarayiciyaGit  	db "open", 0
SCTweb			db "http://www.sctzine.com/",0
format			db "%u",0

tampon2			dd 345d
on				db 10d
.data?

hInstance			dd ?;penceremizin handle'ý
hIkon				dd ?;ikonumuzun handle'ý
hListeKutusu		dd ?;serialimizin handle'ý
hListeKutusu2		dd ?;serialimizin handle'ý
hImlec				dd ?;linke yüklediðimiz imlecin handle'ý

rastsayi			dd ?
tampon				db ?
tampon3				db ?

;#########################################################################
