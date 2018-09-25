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
; Yazar	: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@sctzine.com>
; IDE		: RADAssembler v2.2.2.2 <http://masm32.com/board/index.php?board=24.0>
; Taslak	: BlueDeviL // SCT
; Tarih  	: 05.05.2017
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;								  www.sctzine.com
TITLE  [SCT]CreateFile ReadFile WriteFile Uygulamasi 1		(CreateReadWrite.asm)
.386
.model flat,stdcall
option casemap:none

include CreateReadWrite.Inc

.code
start:
	call main
	exit
	
main proc
	invoke SetConsoleTitle,offset konsolBaslik	;Konsolumuza başlık koyalım
	invoke ClearScreen								;ekranı temizler
	print offset sctGS
	
	push 0				;HANDLE hTemplateFile		NULL olabilir
					;			GENERIC_READ olarak açıldığında bi template handle verilebilir
					;			böylece yaratılırken genişletilmiş özelliklerle yaratılabilir
	push 0				;DWORD	dwFlagsAndAttributes	0x80FILE_ATTRIBUTE_NORMAL
	push 2				;DWORD	dwCreationDisposition	1 ->CREATE_NEW	yeni yaratır zaten yaratılmışsa hata verir
					;				2 ->CREATE_ALWAYS	yeni yaratır ve üzerine yazar
					;				3 ->OPEN_EXISTING	aygıtlar için genelde bu kullanılır
					;				4 ->OPEN_ALWAYS		varolan bir dosyayı açar, bulamazsa hata döndürür
					;				5 ->TRUNCATE_EXISTING	varolan dosyayı açar ve sıfırlar,GENERIC_WRITE set edilmelidir
	push 0				;LPSECURITY_ATTRIBUTES
	push 3				;DWORD	dwShareMode		0 ->Diğer process'les açılan bu dosya üzerinde işlem yapamazlar
					;				1 ->FILE_SHARE_READ	diğer processlerde okuyabilir
					;				2 ->FILE_SHARE_WRITE	yazabilir
					;				3			hem okuyup hem yazabilir
					;				4 ->FILE_SHARE_DELETE	silebilir
	push 0C0000000h			;DWORD	dwDesiredAccess		GENERIC_READ | GENERIC_WRITE
	push offset dosyaYolu		;LPCTSTR	lpFileName
	call CreateFile
					;invoke CreateFile, offset dosyaYolu,GENERIC_READ | GENERIC_WRITE,NULL,NULL,CREATE_ALWAYS,NULL,NULL
					;Başarılı -> dosya, aygıt, named pipe, mail slot ne açıldıysa onun handle'ı döndürür
					;Başarısız-> INVALID_HANDLE_VALUE döndürür.
	cmp eax, INVALID_HANDLE_VALUE
	je _acilamadi
	mov hDosya,eax			;acılanın HANDLE değeri
	print cfm$("\t01. Yazmak icin sorunsuz acildi",13,10)
	
	push offset dosyaMetin
	call lstrlen			;yazılacak metnin uzunluğu
					;invoke lstrlen,offset dosyaMetin ;bu da yukarıdaki iki satırın aynısı
	
	push 0
	push offset NumOfBytesWritten;LPDWORD	lpNumberOfBytesWritten-senkron dosya handle'ndan gelen okunan bayt uzunluğu göstergecidir.
					;Asenkron ise NULL yapılabilir
	push eax			;DWORD		nNumberOfBytesToWrite-aygıt veya dosyaya yazılacak verinin büyüklüğü
	push offset dosyaMetin		;LPCVOID	lpBuffer	ne yazılacaksa bu göstergeç onu saklıyor
	push hDosya			;HANDLE		hFile		CreateFile ile açılan dosya/aygıt/pipe handle değeri
	call WriteFile
					;invoke WriteFile,hDosya,offset dosyaMetin,eax,offset NumOfBytesWritten,0
	print cfm$("\t02. WriteFile txt dosyasina yazdi",13,10)
	push hDosya
	call CloseHandle
	
	invoke CreateFile, offset dosyaYolu,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
	mov hDosya,eax
	print cfm$("\t03. Okumak icin sorunsuz acildi",13,10)
	invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT, BELLEKALANI
	mov hBellek,eax
	invoke GlobalLock,hBellek
	mov dosyaOkunan,eax
	
	push 0				;LPOVERRLAPPED	lpOverlapped	OVERLAPPED yapısına göstergeç-pointer
	push offset NumOfBytesRead	;LPDWORD	lpNumberOfBytesRead	senkron dosya handle'ndan gelen okunan bayt uzunluğu göstergecidir.Asenkron ise NULL yapılabilir
	push BELLEKALANI-1		;DWORD		nNumberOfBytesToRead-okunabilecek max bayt büyüklüğü
	push dosyaOkunan		;LPVOID		lpBuffer			dosya ya da aygıttan okunan bu göstergecin göstereceği alana yazılacak
	push hDosya			;HANDLE		hFile				CreateFile ile açılan dosya/aygıt/pipe handle değeri
	call ReadFile			
					;invoke ReadFile,hDosya,offset dosyaOkunan,15,offset NumOfBytesRead,0
	;invoke StdOut, dosyaOkunan
	print chr$(9)			;9-> sekme
	print dosyaOkunan
	
	invoke GlobalUnlock,hBellek
	invoke GlobalFree,hBellek
	push hDosya
	call CloseHandle
	;invoke CloseHandle,hDosya
	print cfm$("\t04. Uygulamadan cikiyoruz...",13,10)
	jmp _cikis
	
	_acilamadi:
	print cat$(cfm$("\tDosya bulunamadı: "), str$(eax), chr$(13,10))
	
	_cikis:
	inkey
	ret

main endp

end start
