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
; HexDecConverter v1.0
; _______________________________________________________________________________
; Yazar		: BlueDeviL <blau_devil@hotmail.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.2.0 <http://radasm.cherrytree.at/>
; Taslak	: BlueDeviL // SCT
; �������������������������������������������������������������������������������
;																  www.sctzine.com
;fonksiyon tan�m dosyalar�
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include shlwapi.inc		;StrToInt fonksiyonlar�

;fonksiyonlar�n kendilerinin bulundu�u k�t�phaneler
includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
includelib shlwapi.lib

;prototipler
PencereIslemi			PROTO	:HWND,:UINT,:WPARAM,:LPARAM;diyalog i�lemi prototipi
EditAFKontrolu			PROTO	:HWND,:UINT,:WPARAM,:LPARAM	;edtHEX i�in subclassing fonk.
Edit09Kontrolu			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
HexOlarakAl				PROTO	:DWORD,:DWORD				;edite girilen de�eri hex olarak alan fonk. proto.
On2OnA					PROTO	:DWORD						;onluk say�y� hexe �eviren fonk. proto.

;sabitler
.const
pencere					equ 101
edtHEX					equ 1001
edtDECU					equ 1002
edtDECS					equ 1003
lblHEX					equ 1004
lblDECU					equ 1005
lblDECS					equ 1006
btnKAPAT				equ 1007
btnYARDIM				equ 1008

sctIkon					equ 5001

;de�i�kenlerimiz
.data
;a�a��daki format de�i�kenleri "wsprintf" APIsi i�in kullanaca��m�z say� bi�imlerini
;g�steriyor."%x" ile say�m�z� hexe �evirirken, "%lu" ile long unsigned integer'a �eviriyoruz
;daha ayr�nt�l� bilgi i�in w32.hlp'den bu APIyi inceleyiniz.
formatX					db "%08X",0					;edtHEX'e "00000000" i�erisinde hex de�erini yazd�r�r
formatx					db "%X",0					;sadece hexe �evirmek i�in kullanaca��m�z de�i�ken
formatu					db "%lu",0					;long unsigned integer (0 - 4,294,967,295)
formats					db "%li",0					;long signed integer (�2,147,483,648 - 2,147,483,647)

msgBaslik				db "Hakk�nda",0
msgYardim				db "Hex.Dec Converter",13,10,13,10
						db "Onalt�l�k, onluk(singned ve unsigned) say�lar aras�nda",13,10
						db "�evrim yapabilen k���k bir uygulama. Bu uygulama i�erisinde",13,10
						db "bir Onalt�l�k say� nas�l onluk sisteme �evrilir,onluk bir say�",13,10
						db "ise nas�l onalt�l�k say� sistemine �evrilir onu g�receksiniz.",13,10
						db "Ama program�m�z sadece bunlar� kapsam�yor. Ayr�ca Subclassing",13,10
						db "y�ntemini de i�eriyor. Bu y�ntemi kullanarak nas�l bir edite",13,10
						db "sadece bizim istedi�imiz karakterleri yazd�rabiliriz onu da ",13,10
						db "g�receksiniz.Son olarak da EN_CHANGE notice'sinden farkl� olarak",13,10
						db "birka� edit i�erisinde s�rekli �evrimi EN_UPDATE ile ",13,10
						db "yapabilece�iniz de var.",13,10,13,10
						db "Kaynak kodlar� dikkatlice inceleyiniz. Sorular�n�z i�in:",13,10
						db "WEB:",9,"http://www.sctzine.com",13,10
						db "FORUM:",9,"http://mdkgroup.com/forum",13,10,13,10
						db "BlueDeviL",13,10
						db "[SCT]",0

;veri i�eri�i belli olmayan de�i�kenler
.data?
hInstance				dd ?
hIkon					dd ?
EskiPenIslemi			dd ?


CikanDeger				dd 8 dup(?)
CikanDeger2				dd 8 dup(?)
CikanDeger3				dd 8 dup(?)

tampon1					dd 8 dup(?)
tampon2					dd 0Ah dup(?)
tampon3					dd 0Bh dup(?)

tampon1E				dd 8 dup(?)
tampon2E				dd 0Ah dup(?)
tampon3E				dd 0Bh dup(?)

kntrlBAYRAK				DWORD ?

