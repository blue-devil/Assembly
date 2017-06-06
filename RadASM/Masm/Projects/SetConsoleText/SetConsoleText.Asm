; ººº¹¹º¹º¹º¹º¹¹¹ººº¹º¹º¹º¹ººº¹º¹¹¹º¹º¹¹¹º¹º¹¹¹ºº
; º¹|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|¹º
; ºº| ÜÜÛÛÛÛÛÛÛÛÛ   ÜÜÛÛÛÛÛÛÛÜÜ   ÜÛÛÛÛÛÛÛÛÛÜ |º¹
; º¹| ÛÛÛÛÛÛÛÛÛßß   ÛÛÛÛÛÛÛÛÛßß   ßÛÛÛÛÛÛÛÛÛß |¹¹
; ºº| ÛÛ            ÛÛß               ÛÛÛ     |¹º
; ºº| ÛÛ            ÛÛ                ÛÛÛ     |ºº
; ºº| ÛÛÛÛÛÛÛÛÛÜÜ   ÛÛ                ÛÛÛ     |¹¹
; ¹¹| ßßÛÛÛÛÛÛÛÛÛ   ÛÛ                ÛÛÛ     |¹º
; º¹|          ÛÛ   ÛÛ                ÛÛÛ     |¹¹
; ºº|          ÛÛ   ÛÛÜ               ÛÛÛ     |¹¹
; ¹¹| ÜÜÛÛÛÛÛÛÛÛÛ   ÛÛÛÛÛÛÛÛÛÜÜ       ÛÛÛ     |¹º
; ºº| ÛÛÛÛÛÛÛÛÛßß   ßßÛÛÛÛÛÛÛßß       ßÛß     |ºº
; ¹¹|                                         |¹¹
; º¹|                home of secret reversers®|º¹
; ¹¹|_________________________________________|¹¹
; SetConsoleText Uygulaması Taslağı
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@sctzine.com>
; IDE		: RADAssembler v2.2.2.2 <http://masm32.com/board/index.php?board=24.0>
; Taslak	: BlueDeviL // SCT
; Tarih  	: 05.06.2017
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com
TITLE  [SCT]SetConsoleText Uygulamasi	 				  		(SetConsoleText.asm)
.386					;kullandığımız opcodeların hangi işlemci setine bağlı olduğu
.model flat, stdcall	;32 bit hafıza modeli
option casemap :none	;büyük küçük harfe duyarlı

include SetConsoleText.Inc
.code
start:
	call main
	inkey				;çıkmadan önce bekle
	exit
	
main proc
	invoke SetConsoleTitle,addr konsolBaslik		;Konsolumuza başlık koyalım
	invoke ClearScreen								;ekranı temizler
	invoke StdOut, addr sctGS
	
	invoke EyiBas
	print "Eger olumlu sonuc var ise yesil rengi kullanalim!",13,10

	invoke UyariBas
	print "Eger sorun yok ama uyarmak gerekiyorsa sari yazalim",13,10
	
	invoke HataBas
	print "Demek Hata oldu kizil ile gosterelim!",13,10
	
	invoke SetConsoleTextColor, 7, 0
	ret

main endp

SetConsoleTextColor proc fore:DWORD,back:DWORD

    LOCAL hStdOut:DWORD

    invoke GetStdHandle,STD_OUTPUT_HANDLE
    mov   hStdOut,eax
    mov   eax,back
    shl   eax,4
    or    eax,fore
    invoke SetConsoleTextAttribute,hStdOut,eax
    ret
   
SetConsoleTextColor endp

EyiBas proc
	
	invoke SetConsoleTextColor, 7, 0
	print "[ "
	invoke SetConsoleTextColor, 0Ah, 0
	print "OLDU"
	invoke SetConsoleTextColor, 7, 0
	print " ] * "
	ret

EyiBas endp

UyariBas proc
	
	invoke SetConsoleTextColor, 7, 0
	print "["
	invoke SetConsoleTextColor, 9, 0Fh
	print " UYAR "
	invoke SetConsoleTextColor, 7, 0
	print "] * "
	ret

UyariBas endp

HataBas proc
	
	invoke SetConsoleTextColor, 7, 0
	print "[ "
	invoke SetConsoleTextColor, 0Ch, 0
	print "HATA"
	invoke SetConsoleTextColor, 7, 0
	print " ] * "
	ret

HataBas endp

end start
