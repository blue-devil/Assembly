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
; Bellek Ayirma Yordamlari Uygulamasi
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@sctzine.com>
; IDE		: RADAssembler v2.2.2.2 <http://masm32.com/board/index.php?board=24.0>
; Taslak	: BlueDeviL // SCT
; Tarih  	: 05.05.2017
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com
TITLE  [SCT]MemoryAllocation Uygulamasi	 				  (MemoryAlloc.asm)
.386					;kullandigimiz opcodelarin hangi islemci setine bagli oldugu
.model flat, stdcall	;32 bit hafiza modeli
option casemap :none	;büyük kücük harfe duyarli

include MemoryAlloc.Inc

.code
start:
	call main
	inkey				;cikmadan once bekle
	exit
	
main proc 
	invoke SetConsoleTitle,addr konsolBaslik		;konsolumuza baslik koyalim
	invoke ClearScreen								;ekranı temizler
	print offset sctGS
	invoke CreateFile, addr dosyaAdi,GENERIC_READ+GENERIC_WRITE,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
	mov hDosya, eax
	invoke GetFileSize,hDosya,0						;Dosyamızın büyüklüğünü döndürür
	inc eax											;Dosyanın büyüklüğünden en az bir fazla yer ayıracağız
	mov dosyaBoyutu, eax							;o yüzden bir artırıyoruz
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯;
	;      HeapCreate - HeapAlloc - HeapFree Yordamlari						  ;
	;_________________________________________________________________________;
	;invoke GetProcessHeap							;İşletim sistemi bizim için zaten bir heap-yığıt yarattı bu API ile onu çağırabiliriz
													;HeapCreate ile yeni bir yığıt yaratmamız gerekmiyorsa GetProcessHeap kullanmalıyız.
	;invoke HeapCreate,0,HEAP_START,HEAP_MAX		;HeapCreate farkli sekillerde yaratılabilir
	invoke HeapCreate,0,0,0
	.if eax == NULL									;NULL dönerse hata var demektir
		print chr$("[ HATA  ] * Heap yaratilamadi",13,10)
	.else
		mov hHeap,eax
		invoke HeapAlloc,hHeap,HEAP_ZERO_MEMORY,dosyaBoyutu
		.if eax == NULL
			print chr$("[ HATA  ] * heapalloc basaramadi")
		.else
			mov pMemory,eax							;ayrılan bellek bloğunun pointer-göstergeci
			invoke ReadFile,hDosya, pMemory, dosyaBoyutu, offset numBytesRead,NULL
			print cat$(chr$("[ OLDU  ] * Heap yordamlari calisti "), str$(eax), chr$(13,10))
		.endif
		invoke HeapFree,hHeap,0,pMemory				;HeapFree ile Serbest birakiyoruz
	.endif
	invoke SetFilePointer,hDosya,NULL,NULL,FILE_BEGIN;dosya pointerı en başına alalım çünkü tekrar okuyacağız
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯;
	;      GlobalAlloc - GlobalLock - GlobalUnlock - GlobalFree Yordamlari     ;
	;__________________________________________________________________________;
	;invoke GlobalAlloc,GMEM_FIXED,0				;GlobalAlloc farklı şekillerde yaratılabilir 
	invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,dosyaBoyutu
	.if eax == NULL
		print chr$("[ HATA  ] * error from GlobalAlloc")
	.else
		mov hGMemory,eax
		invoke GlobalLock,hGMemory
		mov pGMemory,eax
		invoke ReadFile,hDosya,pGMemory,dosyaBoyutu, offset numBytesRead, NULL
		print cat$(chr$("[ OLDU  ] * Global yordamlari calisti "), str$(eax) ,chr$(13,10))
		invoke GlobalUnlock,pGMemory
	.endif
	invoke GlobalFree,hGMemory
	invoke SetFilePointer,hDosya,NULL,NULL,FILE_BEGIN
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯;
	;      LocalAlloc - LocalLock - LocalUnlock - LocalFree Yordamlari	       ;
	;__________________________________________________________________________;
	invoke LocalAlloc,LMEM_MOVEABLE or LMEM_ZEROINIT,dosyaBoyutu
	.if eax == NULL
		print chr$("[ HATA  ] * error from LocalAlloc",13,10)
	.else
		mov hLMemory,eax
		invoke LocalLock,hLMemory
		mov pLMemory,eax
		;
		invoke ReadFile,hDosya,pLMemory,dosyaBoyutu, offset numBytesRead, NULL
		print cat$(chr$("[ OLDU  ] * Local yordamlari calisti "), str$(eax) ,chr$(13,10))
		;
		invoke LocalUnlock,pLMemory
	.endif
	invoke LocalFree,hLMemory
	invoke SetFilePointer,hDosya,NULL,NULL,FILE_BEGIN
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯;
	;      VirtualAlloc - VirtualLock - VirtualUnlock - VirtualFree Yordamlari ;
	;__________________________________________________________________________;
	invoke VirtualAlloc, NULL, 1024000, MEM_COMMIT, PAGE_READWRITE
	.if eax == NULL
		print chr$("[ HATA  ] * error from VirtualAlloc",13,10)
	.else
		mov pVMemory,eax
		invoke VirtualLock,pVMemory,dosyaBoyutu
		invoke ReadFile,hDosya,pVMemory,dosyaBoyutu, offset numBytesRead, NULL
		print cat$(chr$("[ OLDU  ] * Virtual yordamlari calisti "), str$(eax) ,chr$(13,10))
		invoke VirtualUnlock,pVMemory,dosyaBoyutu
	.endif
	invoke VirtualFree,pVMemory,dosyaBoyutu,MEM_RELEASE
	
	invoke HeapDestroy,hHeap
	;invoke ExitProcess,0			;ret yerine bu da kullanılabilir
									;ama ret kullanmak daha hesaplı+
	ret

main endp

end start
