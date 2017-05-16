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

;prototipler
subStrBirlestir			PROTO	:ptr,:ptr,:ptr
subStrYerDegistir		PROTO	:ptr,:ptr,:ptr,:ptr

;sabitler
.const

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
	konsolBaslik		db	"[SCT]RadASM Konsol Uygulamasi Taslagi ",0 
	strBulunacak		db	"metin",0
	strDegistirilecek	db	"dizi",0
	strBirinci			db	"ilk metin",0
	strIkinci			db	"ikinci metin",0
	strBirlesmis		db	sizeof strBirinci + sizeof strIkinci +1 dup(0)
	strYerDegismis		db	$-strBirlesmis + sizeof strDegistirilecek - sizeof strBulunacak dup(0)
	
	
;veribќyќklќ№ќ belli olmayan de№iўkenler
.data?
	genelTampon 		db 1024 (?)
