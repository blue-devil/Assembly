; ÌÎÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÊÎ?
; Ì?ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?Ì?
; Ì?? ÜÜÛÛÛÛÛÛÛÛÛ   ÜÜÛÛÛÛÛÛÛÜÜ   ÜÛÛÛÛÛÛÛÛÛÜ ?Ì?
; Ì?? ÛÛÛÛÛÛÛÛÛßß   ÛÛÛÛÛÛÛÛÛßß   ßÛÛÛÛÛÛÛÛÛß ?Ì?
; Ì?? ÛÛ            ÛÛß               ÛÛÛ     ?Ì?
; Ì?? ÛÛ            ÛÛ                ÛÛÛ     ?Ì?
; Ì?? ÛÛÛÛÛÛÛÛÛÜÜ   ÛÛ                ÛÛÛ     ?Ì?
; Ì?? ßßÛÛÛÛÛÛÛÛÛ   ÛÛ                ÛÛÛ     ?Ì?
; Ì??          ÛÛ   ÛÛ                ÛÛÛ     ?Ì?
; Ì??          ÛÛ   ÛÛÜ               ÛÛÛ     ?Ì?
; Ì?? ÜÜÛÛÛÛÛÛÛÛÛ   ÛÛÛÛÛÛÛÛÛÜÜ       ÛÛÛ     ?Ì?
; Ì?? ÛÛÛÛÛÛÛÛÛßß   ßßÛÛÛÛÛÛÛßß       ßÛß     ?Ì?
; Ì??                                         ?Ì?
; Ì??                home of secret reversers®?Ì?
; Ì?ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?Ì?
; HexBinConverter v1.0
; _______________________________________________________________________________
; Yazar		: BlueDeviL <blau_devil@hotmail.com>
; Tester	: ErrorInside <errorinside@hotmail.com>
; IDE		: RADAssembler v2.2.2.0 <http://radasm.cherrytree.at/>
; Taslak	: BlueDeviL // SCT
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com
;fonksiyon tanım dosyaları
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include shlwapi.inc		;StrToInt fonksiyonları

;fonksiyonların kendilerinin bulunduğu kütüphaneler
includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

PencereIslemi	PROTO	:HWND,:UINT,:WPARAM,:LPARAM
EditAFKontrolu	PROTO	:HWND,:UINT,:WPARAM,:LPARAM	;edtHEX için subclassing fonk.
EditIkiKontrolu	PROTO	:DWORD,:DWORD,:DWORD,:DWORD	;edtBIN için subclassing fonk.
HexOlarakAl		PROTO	:DWORD,:DWORD				;edite girilen değeri hex olarak alan fonk. proto.
Iki2OnA			PROTO	:DWORD,:DWORD				;ikilk değeri onaltılık değere çevirir
OnA2Iki			PROTO	:DWORD						;onaltılık değeri ikilik değere çevirir

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

;değişkenlerimiz
.data
formatX					db "%08X",0					;edtHEX'e "00000000" içerisinde hex değerini yazdırır
formats					db "%li",0					;long signed integer (–2,147,483,648 - 2,147,483,647)
format0					db "%032u",0
formatubits				db "%lu bit",0
msgBaslik				db "Hakkında",0
msgYardim				db "Hex.Bin Converter",13,10,13,10
						db "Onaltılık ve ikilik sayılar arasında çevrim yapabilen basit",13,10
						db "bir araç. Assembly öğrenirken sayı sistemlerini ve bu tabanlar",13,10
						db "arası geçişleri çok iyi bilmek ve anlamış olak gerekir.",13,10
						db "Bu amaçla yazdığım ikinci küçük uygulama. Edite girilen",13,10
						db "onaltılık sayıyı yazmaca alan bir fonksiyon sayesinde bu rakam",13,10
						db "üzerinde rahatlıkla oynuyorum. Böylelikle sayıları mıncıklamak",13,10
						db "daha kolay oluyor.",13,10,13,10
						db "Kaynak kodları dikkatlice inceleyiniz.",13,10
						db "Sorularınız ve hata bildirimi için:",13,10
						db "EPOSTA:",9,"bluedevil@sctzine.com",13,10
						db "WEB:",9,"http://www.sctzine.com",13,10
						db "FORUM:",9,"http://mdkgroup.com/forum",13,10,13,10
						db "BlueDeviL",13,10
						db "[SCT]",0
;veri içeriği belli olmayan değişkenler
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
