;fonksiyon taným dosyalarý
include windows.inc
include user32.inc
include kernel32.inc
include comctl32.inc
include comdlg32.inc
include shell32.inc
include advapi32.inc
Include AniGIF.inc
include ufmod.inc

;makrolar
include \masm32\macros\macros.asm

;fonksiyonlarýn kendilerinin bulunduðu kütüphaneler
includelib winmm.lib
includelib user32.lib
includelib kernel32.lib
includelib comctl32.lib
includelib comdlg32.lib
includelib shell32.lib
includelib advapi32.lib
IncludeLib AniGIF.lib
includelib ufmod.lib

;prototipler
PencereIslemi			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
ImlecYukle				PROTO	:HWND,:UINT,:WPARAM,:LPARAM;imleçyükle iþlemi prototipi ile linke imleç yüklüyoruz
SaydamPencere			PROTO 	:DWORD,:DWORD
SerialUret				PROTO	:DWORD

;sabitler
.const
pencere				equ 101
muzik				equ 500
logoGif				equ	501
MAXSIZE				equ	512

rsmLOGO				equ 1001
grpAdSerial			equ 1002
lblAd				equ 1003
lblSerial			equ 1004
edtAd				equ 1005
edtSerial			equ 1006
lblLink				equ 1007
btnKapat			equ 1008
btnHakkinda			equ 1009
btnKopyala			equ 1010
btnUret				equ 1011
aniLogo				equ	1012

TransparanDerece	equ 200 ;Transparanlýk derecesi ( en fazla 254 )

PUBLIC hInstance

;deðiþkenlerimiz
.data
msgBaslik		db "Hakkýnda",0
msgHakkinda		db "[SCT]Keygen Template for SCTZine 2017",13,10,13,10
				db "Esen!",13,10
				db "Rnd0M bugün benden keygen projelerinde, Bitmap",13,10
				db "yerine hareketli GIF kullanabilir miyiz diye",13,10
				db "mesaj göndermiþ. Tabi kýramadým ve bir taslak",13,10
				db "hazýrladým. Rnd0M kardeþim artýk bir kahve ýsmarlarsýn =)",13,10,13,10
				db "Assembly içerisinde GIF kullanmak gerçekten sýkýntý.",13,10
				db "Harici ibr kütüphane buldum onu kullanarak bu",13,10
				db "keygen taslaðýný hazýrladým. GIF kullanmak ile ilgili",13,10
				db "lisans sorunlarý varmýþ ama çözülmüþ galiba neyse..",13,10,13,10
				db "Özellikler:",13,10
				db "Müzik, saydamlýk, link ve hazýr çalýþan butonlar.",13,10
				db "Ayrýca hareketli canlý kanlý bir GIF!",13,10,13,10
				db "Yazan:",9,"BlueDeviL // SCT",13,10
				db "Tester:",9,"Rnd0M // Decompile.us",13,10
				db "Tarih:",9,"17.05.2017",13,10
				db "E-Posta:",9,"bluedevil@sctzine.com",13,10,13,10
				db "Teþekkürler",13,10
				db "Errorinside, Infexia, Yakuter, Rnd0M",13,10
				db "[SCT] 2017",0

TarayiciyaGit  	db "open", 0
SCTweb			db "http://www.sctzine.com/",0

;veribüyüklüðü belli olmayan deðiþkenler
.data?
hInstance		dd ?
hSerial			dd ?;serialimizin handle'ý
hImlec			dd ?
hWAGif			HWND		?
hLib			DWORD		?
szName      	db  MAXSIZE	dup(?)
szSerial      	db  MAXSIZE	dup(?)
szHash			db  MAXSIZE	dup(?)
szHash2			db  MAXSIZE	dup(?)
szHashMD5		db  MAXSIZE	dup(?)
szLenH1			db  MAXSIZE	dup(?)
szBuff1			db  MAXSIZE	dup(?)
szBuff2			db  MAXSIZE	dup(?)
