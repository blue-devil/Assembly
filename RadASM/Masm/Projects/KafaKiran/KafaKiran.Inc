include windows.inc
include kernel32.inc
include user32.inc
include masm32.inc
include gdi32.inc
include comctl32.inc



includelib kernel32.lib
includelib comctl32.lib
includelib user32.lib
includelib masm32.lib
includelib gdi32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
YamaIslemi		PROTO	:DWORD

.data
DosyaAdi db "filename.exe", 0;buras� �nemli sakatlayaca��m�z dosyan�n ismini buraya tam olarak girmeliyiz

hataBASLIK		db "[SCT]Hata",0
hataACMA		db "Dosya Bulunamad�!",0
hataBOYUT		db "Dosya boyutu al�namad� - �ptal Ediliyor..",0
hataHAFIZA		db "Yetersiz Haf�za",0
hataOKUMA		db "Dosyay� Okuyam�yorum",0
hataBAYT		db "Dosya e�le�tirilemiyor yada zaten yamalanm��!",0
hataYAZMA		db "Dosyaya yazam�yorum",0

hzrMETIN		db "Dosya Sakatland�",0
hzrBASLIK		db "[SCT]Tebrikler",0

msgBASLIK		db "[SCT]Hakk�nda",0
msgHAKKINDA		db "[SCT] KafaK�ran v1.0",13,10,13,10
				db "Coded by Blue DeviL //SCT",13,10
				db "http://www.sctzine.com/",13,10,13,10
				db "Koruma:",9,9,"Zaman Korumas�",13,10
				db "Hedef Dosya:",9,"filename.exe",13,10
				db "Dosya Boyutu:",9,"2560 Bayt",13,10,13,10
				db "�ld�rmeyen Her Darbe G�ce G�� Katar",13,10
				db "[SCT] 2007",0

;**************YAMA VER�LER�***************************************
;-------------orijinal dosyan�n baytlar�---------------------------
yamaORIJINAL	db 073h,065h,06Ch,061h,06Dh

;-------------de�i�en baylar---------------------------------------
yamaDEGISEN		db 062h,06Ch,075h,065h,020h

;------------De�i�en baytlar�n offsetleri(adresleri)---------------
yamaADRES		dd 000000800h,000000801h,000000802h,000000803h,000000804h

sayac			dd 0

.data?
hInstance		HANDLE ?
hDosya 			HANDLE ?
hHafiza			HANDLE ?

BaytOku 		DWORD ?
BaytYaz			dd ?
HafizaBoyutu	dd ?
hIcon			dd ?


.const

dialogANA			equ 101
btnYAMA				equ 1001
btnHAKKINDA			equ 1002
btnCIKIS			equ 1003
imgSCT				equ 5000
fark				equ yamaDEGISEN-yamaORIJINAL