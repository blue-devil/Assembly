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
; HexBinConverter v1.0
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

PencereIslemi	PROTO	:HWND,:UINT,:WPARAM,:LPARAM
EditAFKontrolu	PROTO	:HWND,:UINT,:WPARAM,:LPARAM	;edtHEX i�in subclassing fonk.
EditIkiKontrolu	PROTO	:DWORD,:DWORD,:DWORD,:DWORD	;edtBIN i�in subclassing fonk.
HexOlarakAl		PROTO	:DWORD,:DWORD				;edite girilen de�eri hex olarak alan fonk. proto.
Iki2OnA			PROTO	:DWORD,:DWORD				;ikilk de�eri onalt�l�k de�ere �evirir
OnA2Iki			PROTO	:DWORD						;onalt�l�k de�eri ikilik de�ere �evirir

;sabitler
.const
pencere			equ 101
edtHEX			equ 1004
edtDEC			equ 1005
edtBIN			equ 1006
edtBIN2			equ 1007
btnKAPAT		equ 1008
btnYARDIM		equ 1009
lblBITS			equ 1012


sctIkon			equ 5001

;de�i�kenlerimiz
.data
formatX					db "%08X",0					;edtHEX'e "00000000" i�erisinde hex de�erini yazd�r�r
formats					db "%li",0					;long signed integer (�2,147,483,648 - 2,147,483,647)
format0					db "%032u",0
formatubits				db "%lu bit",0
msgBaslik				db "Hakk�nda",0
msgYardim				db "Hex.Bin Converter",13,10,13,10
						db "Onalt�l�k ve ikilik say�lar aras�nda �evrim yapabilen basit",13,10
						db "bir ara�. Assembly ��renirken say� sistemlerini ve bu tabanlar",13,10
						db "aras� ge�i�leri �ok iyi bilmek ve anlam�� olak gerekir.",13,10
						db "Bu ama�la yazd���m ikinci k���k uygulama. Edite girilen",13,10
						db "onalt�l�k say�y� yazmaca alan bir fonksiyon sayesinde bu rakam",13,10
						db "�zerinde rahatl�kla oynuyorum. B�ylelikle say�lar� m�nc�klamak",13,10
						db "daha kolay oluyor.",13,10,13,10
						db "Kaynak kodlar� dikkatlice inceleyiniz.",13,10
						db "Sorular�n�z ve hata bildirimi i�in:",13,10
						db "EPOSTA:",9,"bluedevil@sctzine.com",13,10
						db "WEB:",9,"http://www.sctzine.com",13,10
						db "FORUM:",9,"http://mdkgroup.com/forum",13,10,13,10
						db "BlueDeviL",13,10
						db "[SCT]",0
;veri i�eri�i belli olmayan de�i�kenler
.data?

hInstance		dd ?
EskiPenIslemi	dd ?

CikanDeger		dd 8 dup(?)
CikanDeger2		dd 8 dup(?)
CikanDeger3		dd 8 dup(?)

tampon1			dd 8 dup(?)
tampon2			dd 20h dup(?)
tampon3			dd 0Ah dup(?)
tampon4			dd ?

tampon1E		dd 8 dup(?)
tampon2E		dd 0Ah dup(?)
tampon3E		dd 0Bh dup(?)

kntrlBAYRAK		DWORD ?
