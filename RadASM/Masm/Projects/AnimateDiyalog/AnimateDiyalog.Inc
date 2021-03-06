;fonksiyon tan�m dosyalar�
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc

;fonksiyonlar�n kendilerinin bulundu�u k�t�phaneler
includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

;prototipler
PencereIslemi			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
TestPenceresi			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
ImlecYukle				PROTO	:HWND,:UINT,:WPARAM,:LPARAM;imle�y�kle i�lemi prototipi ile linke imle� y�kl�yoruz

;sabitler
.const
pencere					equ 101
testpencere				equ 200

rbnSoldanSaga 			equ 1004
rnbSagdanSola 			equ 1005
rbnYukaridanAsagiya 	equ 1006
rbnAsagidanYukariya 	equ 1007
rbnMerkeze 				equ 1008
rbnBlending 			equ 1009
rbnDgnlSoldanSaga 		equ 1010
rbnDgnlSagdanSola 		equ 1011
rbnSoldanKaydir			equ 1012
rbnSagdanKaydir			equ 1013

rbnKSoldanKaydir		equ 1014
rbnKSagdanKaydir		equ 1015
rbnKDgnlSagdanSola 		equ 1016
rbnKDgnlSoldanSaga 		equ 1017
rbnKBlending 			equ 1018
rbnKMerkeze 			equ 1019
rbnKAsagidanYukariya 	equ 1020
rbnKYukaridanAsagiya 	equ 1021
rnbKSagdanSola 			equ 1022
rbnKSoldanSaga 			equ 1023
lblLINK					equ 1024

btnTest 				equ 1025
btnHakkinda 			equ 1026
btnKapat				equ 1027

lblAciklamaA			equ 202
lblAciklamaK			equ 203
btnKKapat				equ 204

;de�i�kenlerimiz
.data
msgBaslik				db "Hakk�nda",0
msgHakkinda				db "Diyalog Animasyonlar�",13,10,13,10
						db "Yazar:",9,"BlueDeviL // SCT",13,10
						db "Tarih:",9,"04.11.2012",13,10
						db "E-Posta:",9,"bluedevil@sctzine.com",13,10,13,10
						db "Te�ekk�rler",13,10
						db "MDKGroup, Vona, hutch--, ragdog",13,10
						db "[SCT] 2012",0
				
TarayiciyaGit  			db "open", 0
SCTweb					db "http://www.sctzine.com/",0
format					db "%u",0

;veri i�eri�i belli olmayan de�i�kenlerimiz
.data?
hInstance				dd ?
hMain					dd ? ;penceremizin(diyalog) handle'�
hIkon					dd ? ;ikonumuzun handle de�eri
hImlec					dd ? ;imlecimizin handle de�eri

