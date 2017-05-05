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
DosyaAdi db "filename.exe", 0;burasý önemli sakatlayacaðýmýz dosyanýn ismini buraya tam olarak girmeliyiz

hataBASLIK		db "[SCT]Hata",0
hataACMA		db "Dosya Bulunamadý!",0
hataBOYUT		db "Dosya boyutu alýnamadý - Ýptal Ediliyor..",0
hataHAFIZA		db "Yetersiz Hafýza",0
hataOKUMA		db "Dosyayý Okuyamýyorum",0
hataBAYT		db "Dosya eþleþtirilemiyor yada zaten yamalanmýþ!",0
hataYAZMA		db "Dosyaya yazamýyorum",0

hzrMETIN		db "Dosya Sakatlandý",0
hzrBASLIK		db "[SCT]Tebrikler",0

msgBASLIK		db "[SCT]Hakkýnda",0
msgHAKKINDA		db "[SCT] KafaKýran v1.0",13,10,13,10
				db "Coded by Blue DeviL //SCT",13,10
				db "http://www.sctzine.com/",13,10,13,10
				db "Koruma:",9,9,"Zaman Korumasý",13,10
				db "Hedef Dosya:",9,"filename.exe",13,10
				db "Dosya Boyutu:",9,"2560 Bayt",13,10,13,10
				db "Öldürmeyen Her Darbe Güce Güç Katar",13,10
				db "[SCT] 2007",0

;**************YAMA VERÝLERÝ***************************************
;-------------orijinal dosyanýn baytlarý---------------------------
yamaORIJINAL	db 073h,065h,06Ch,061h,06Dh

;-------------deðiþen baylar---------------------------------------
yamaDEGISEN		db 062h,06Ch,075h,065h,020h

;------------Deðiþen baytlarýn offsetleri(adresleri)---------------
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