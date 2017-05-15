;fonksiyon tan§m dosyalar§
include windows.inc					;windows.inc her zaman en ќstte

include masm32.inc
include user32.inc
include msvcrt.inc
include kernel32.inc

;masm32 makrolar§
include \masm32\macros\macros.asm

;fonksiyonlar§n kendilerinin bulundu№u kќtќphaneler
includelib masm32.lib
includelib user32.lib
includelib msvcrt.lib
includelib kernel32.lib

;sabitler
.const
	HEAP_START 			equ 2000000 ; 2 MByte
	HEAP_MAX 			equ 400000000 ; 400 MByte
	BLOCK_SIZE 			equ 500000 ; .5 MByte
;de№iўkenlerimiz
.data
	sctGS				db  "        кФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФП",13,10
						db	"      кФй                                                                 РФП",13,10
						db	"      Г       мммммммллллллммм             мммммм         мллллллллллллллллмГ",13,10
						db	"      Г     млллллллл   ллллллллм       млллллллллллммм   пллллллллллллллллпГ",13,10
						db	"      Г     ллллллллл   ллллллллл     мллллллл   ллллллл        пллллп      Г",13,10
						db	"      Г    ллллллллл    ллллллллл     ллллллл    ллллллл         лллл       Г",13,10
						db	"      Г    ллллллллл  млллллллллл    лллллллл    лллллллл        лллл       Г",13,10
						db	"      Г     лллллллл         пппп    лллллллл    ллллппп         лллл       Г",13,10
						db	"      Г       ллллллл                ллллллл   ппп               лллл       Г",13,10
						db	"      Г       ппллллллллллммм        ллллллл                     лллл       Г",13,10
						db	"      Г    мм       пппллллллллм     ллллллл         мммм        лллл       Г",13,10
						db	"      Г    ллллллммм     ллллллл     ллллллл   мммлллллл         лллл       Г",13,10
						db	"      Г    ллллллллл     лллллллл    лллллллл    ллллллл         лллл       Г",13,10
						db	"      Г    ллллллллл     ллллллл      ллллллл    ллллллл         лллл       Г",13,10
						db	"      Г    пллллллл      ллллллп      плллллл    лллллл          лллл       Г",13,10
						db	"      Г      пппллллллллллллпп          ппллллллллллпп           лллл       Г",13,10
						db	"      Г          пппппп                   пплпп                  пппп       Г",13,10
						db	"      Г                                                                     Г",13,10
						db	"      Г             ФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФ               Г",13,10
						db	"      Г                  g u r u r l a     s u n a r                        Г",13,10
						db	"      Г             ФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФ               Г",13,10
						db	"      РФП                                                 www.sctzine.com кФй",13,10
						db	"        РФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФй",13,10,0
	konsolBaslik		db	"[SCT]MemoryAllocation Uygulamasi",0 
	dosyaAdi			db	"filename.exe",0

;veribќyќklќ№ќ belli olmayan de№iўkenler
.data?
	hDosya				HANDLE	?
	hHeap				HANDLE	?
	hMemory				HANDLE	?
	pMemory				DWORD	?
	hGMemory			HANDLE	?
	pGMemory			DWORD	?
	hLMemory			HANDLE	?
	pLMemory			DWORD	?
	hVMemory			HANDLE	?
	pVMemory			DWORD	?
	dosyaBoyutu			DWORD	?
	numBytesRead		DWORD	?
	Comment @ Bu kadar чok de№iўken tan§mlamaya gerek yoktu
			Sadece yordamlardaki kullan§mlar§ daha belirgin olsun istedim@
