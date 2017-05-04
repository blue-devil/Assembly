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
; HexDecConverter v1.0
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
includelib shlwapi.lib

;prototipler
PencereIslemi			PROTO	:HWND,:UINT,:WPARAM,:LPARAM;diyalog işlemi prototipi
EditAFKontrolu			PROTO	:HWND,:UINT,:WPARAM,:LPARAM	;edtHEX için subclassing fonk.
Edit09Kontrolu			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
HexOlarakAl				PROTO	:DWORD,:DWORD				;edite girilen değeri hex olarak alan fonk. proto.
On2OnA					PROTO	:DWORD						;onluk sayıyı hexe çeviren fonk. proto.

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

;değişkenlerimiz
.data
;aşağıdaki format değişkenleri "wsprintf" APIsi için kullanacağımız sayı biçimlerini
;gösteriyor."%x" ile sayımızı hexe çevirirken, "%lu" ile long unsigned integer'a çeviriyoruz
;daha ayrıntılı bilgi için w32.hlp'den bu APIyi inceleyiniz.
formatX					db "%08X",0					;edtHEX'e "00000000" içerisinde hex değerini yazdırır
formatx					db "%X",0					;sadece hexe çevirmek için kullanacağımız değişken
formatu					db "%lu",0					;long unsigned integer (0 - 4,294,967,295)
formats					db "%li",0					;long signed integer (–2,147,483,648 - 2,147,483,647)

msgBaslik				db "Hakkında",0
msgYardim				db "Hex.Dec Converter",13,10,13,10
						db "Onaltılık, onluk(singned ve unsigned) sayılar arasında",13,10
						db "çevrim yapabilen küçük bir uygulama. Bu uygulama içerisinde",13,10
						db "bir Onaltılık sayı nasıl onluk sisteme çevrilir,onluk bir sayı",13,10
						db "ise nasıl onaltılık sayı sistemine çevrilir onu göreceksiniz.",13,10
						db "Ama programımız sadece bunları kapsamıyor. Ayrıca Subclassing",13,10
						db "yöntemini de içeriyor. Bu yöntemi kullanarak nasıl bir edite",13,10
						db "sadece bizim istediğimiz karakterleri yazdırabiliriz onu da ",13,10
						db "göreceksiniz.Son olarak da EN_CHANGE notice'sinden farklı olarak",13,10
						db "birkaç edit içerisinde sürekli çevrimi EN_UPDATE ile ",13,10
						db "yapabileceğiniz de var.",13,10,13,10
						db "Kaynak kodları dikkatlice inceleyiniz. Sorularınız için:",13,10
						db "WEB:",9,"http://www.sctzine.com",13,10
						db "FORUM:",9,"http://mdkgroup.com/forum",13,10,13,10
						db "BlueDeviL",13,10
						db "[SCT]",0

;veri içeriği belli olmayan değişkenler
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

