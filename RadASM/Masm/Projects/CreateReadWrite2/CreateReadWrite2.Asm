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
; CreateFile ReadFile WriteFile Uygulaması 2
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@sctzine.com>
; IDE		: RADAssembler v2.2.2.2 <http://masm32.com/board/index.php?board=24.0>
; Taslak	: BlueDeviL // SCT
; Tarih  	: 05.05.2017
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com
TITLE  [SCT]CreateFile ReadFile WriteFile Uygulamasi 2			  (CreateReadWrite2.asm)
<<<<<<< Updated upstream
.386					;kullandýðýmýz opcodelarýn hangi iþlemci setine baðlý olduðu
.model flat, stdcall	;32 bit hafýza modeli
option casemap :none	;büyük küçük harfe duyarlý
=======
.386					;kullandığımız opcodeların hangi işlemci setine bağlı olduğu
.model flat, stdcall	;32 bit hafıza modeli
option casemap :none	;büyük küçük harfe duyarlı
>>>>>>> Stashed changes


include CreateReadWrite2.Inc

.code
start:
	call main
<<<<<<< Updated upstream
	inkey											;çýkmadan önce bekle
	exit
	
main proc
	invoke SetConsoleTitle,offset konsolBaslik		;Konsolumuza baþlýk koyalým
	invoke ClearScreen								;ekraný temizler
=======
	inkey											;çıkmadan önce bekle
	exit
	
main proc
	invoke SetConsoleTitle,offset konsolBaslik		;Konsolumuza başlık koyalım
	invoke ClearScreen								;ekranı temizler
>>>>>>> Stashed changes
	print offset sctGS
	
	invoke CreateFile,offset pDosyaYolu,GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ or FILE_SHARE_WRITE,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
	mov hDosya,eax
	invoke GetLastError								;Hata Kodu Döndürür.
	.if eax == INVALID_HANDLE_VALUE
		print cat$(chr$("[ HATA  ] * Dosya acmada hata. Hata Kodu: "), str$(eax),chr$(13,10))
	.elseif eax == ERROR_FILE_EXISTS
		print cat$(chr$("[ UYARI ] * Dosya zaten yaratilmis! Hata Kodu: "), str$(eax),chr$(13,10))
	.elseif eax == ERROR_ALREADY_EXISTS
		invoke CloseHandle,offset hDosya
		invoke CreateFile,offset pDosyaYolu,GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ or FILE_SHARE_WRITE,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
		print cat$(chr$("[ UYARI ] * Dosya zaten yaratilmis! Hata Kodu: "), str$(eax),chr$(13,10))
		invoke ReadFile,hDosya,offset genelTampon,100,offset NumOfBytesRead,NULL
		invoke StdOut,offset genelTampon
<<<<<<< Updated upstream
		invoke CloseHandle,hDosya					;handle'ý kapatmayý unutmayalým
	.else
		invoke lstrlen,offset strMetin				;yazdýracaðýmýz metnin uzunluðunu eax'e döndürüyor
		mov intUzunluk,eax
		invoke WriteFile,hDosya,offset strMetin,eax,offset NumOfBytesWritten,NULL
		invoke SetFilePointerEx,hDosya,NULL,NULL,FILE_BEGIN,0	;WriteFile ile metni yazdýrdýktan sonra file pointer dosyanýn sonunda
																;pointer'ý dosyanýn en baþýna aldýrýyorum
																;böylece okuma iþlemini en baþýndan yapacaðým
		invoke ReadFile,hDosya,offset genelTampon,intUzunluk,offset NumOfBytesRead,NULL
		invoke StdOut,offset genelTampon
		invoke CloseHandle,hDosya					;handle'ý kapatmayý unutmayalým
=======
		invoke CloseHandle,hDosya					;handle'ı kapatmayı unutmayalım
	.else
		invoke lstrlen,offset strMetin				;yazdıracağımız metnin uzunluğunu eax'e döndürüyor
		mov intUzunluk,eax
		invoke WriteFile,hDosya,offset strMetin,eax,offset NumOfBytesWritten,NULL
		invoke SetFilePointerEx,hDosya,NULL,NULL,FILE_BEGIN,0	;WriteFile ile metni yazdırdıktan sonra file pointer dosyanın sonunda
																;pointer'ı dosyanın en başına aldırıyorum
																;böylece okuma işlemini en başından yapacağım
		invoke ReadFile,hDosya,offset genelTampon,intUzunluk,offset NumOfBytesRead,NULL
		invoke StdOut,offset genelTampon
		invoke CloseHandle,hDosya					;handle'ı kapatmayı unutmayalım
>>>>>>> Stashed changes
	.endif
	
	ret

main endp

end start
