; _______________________________________________________________________________
;   include files
include windows.inc		;windows.inc her zaman en üstte

include masm32.inc
include user32.inc
include msvcrt.inc
include kernel32.inc

; _______________________________________________________________________________
;masm32 macros
include \masm32\macros\macros.asm

; _______________________________________________________________________________
;   libraries
includelib masm32.lib
includelib user32.lib
includelib msvcrt.lib
includelib kernel32.lib

; _______________________________________________________________________________
;   constant variables
.const
	MAXSIZE			equ	512

; _______________________________________________________________________________
;   initialized variables
.data
	sctGS			db	"        ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿",13,10
				db	"      ÚÄÙ                                                                 ÀÄ¿",13,10
				db	"      ³       ÜÜÜÜÜÜÜÛÛÛÛÛÛÜÜÜ             ÜÜÜÜÜÜ         ÜÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÜ³",13,10
				db	"      ³     ÜÛÛÛÛÛÛÛÛ   ÛÛÛÛÛÛÛÛÜ       ÜÛÛÛÛÛÛÛÛÛÛÛÜÜÜ   ßÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛß³",13,10
				db	"      ³     ÛÛÛÛÛÛÛÛÛ   ÛÛÛÛÛÛÛÛÛ     ÜÛÛÛÛÛÛÛ   ÛÛÛÛÛÛÛ        ßÛÛÛÛß      ³",13,10
				db	"      ³    ÛÛÛÛÛÛÛÛÛ    ÛÛÛÛÛÛÛÛÛ     ÛÛÛÛÛÛÛ    ÛÛÛÛÛÛÛ         ÛÛÛÛ       ³",13,10
				db	"      ³    ÛÛÛÛÛÛÛÛÛ  ÜÛÛÛÛÛÛÛÛÛÛ    ÛÛÛÛÛÛÛÛ    ÛÛÛÛÛÛÛÛ        ÛÛÛÛ       ³",13,10
				db	"      ³     ÛÛÛÛÛÛÛÛ         ßßßß    ÛÛÛÛÛÛÛÛ    ÛÛÛÛßßß         ÛÛÛÛ       ³",13,10
				db	"      ³       ÛÛÛÛÛÛÛ                ÛÛÛÛÛÛÛ   ßßß               ÛÛÛÛ       ³",13,10
				db	"      ³       ßßÛÛÛÛÛÛÛÛÛÛÜÜÜ        ÛÛÛÛÛÛÛ                     ÛÛÛÛ       ³",13,10
				db	"      ³    ÜÜ       ßßßÛÛÛÛÛÛÛÛÜ     ÛÛÛÛÛÛÛ         ÜÜÜÜ        ÛÛÛÛ       ³",13,10
				db	"      ³    ÛÛÛÛÛÛÜÜÜ     ÛÛÛÛÛÛÛ     ÛÛÛÛÛÛÛ   ÜÜÜÛÛÛÛÛÛ         ÛÛÛÛ       ³",13,10
				db	"      ³    ÛÛÛÛÛÛÛÛÛ     ÛÛÛÛÛÛÛÛ    ÛÛÛÛÛÛÛÛ    ÛÛÛÛÛÛÛ         ÛÛÛÛ       ³",13,10
				db	"      ³    ÛÛÛÛÛÛÛÛÛ     ÛÛÛÛÛÛÛ      ÛÛÛÛÛÛÛ    ÛÛÛÛÛÛÛ         ÛÛÛÛ       ³",13,10
				db	"      ³    ßÛÛÛÛÛÛÛ      ÛÛÛÛÛÛß      ßÛÛÛÛÛÛ    ÛÛÛÛÛÛ          ÛÛÛÛ       ³",13,10
				db	"      ³      ßßßÛÛÛÛÛÛÛÛÛÛÛÛßß          ßßÛÛÛÛÛÛÛÛÛÛßß           ÛÛÛÛ       ³",13,10
				db	"      ³          ßßßßßß                   ßßÛßß                  ßßßß       ³",13,10
				db	"      ³                                                                     ³",13,10
				db	"      ³             ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ               ³",13,10
				db	"      ³                  g u r u r l a     s u n a r                        ³",13,10
				db	"      ³             ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ               ³",13,10
				db	"      ÀÄ¿                                                 www.sctzine.com ÚÄÙ",13,10
				db	"        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ",13,10,0
	konsolBaslik		db	"[SCT]Concatenate2Str MASM32 Sample Code ",0 
	strLine01		db	"First half of my line",0
	strLine02		db	", second half of my line",0
	strNum01		db	"First grasshopper jumps, ",0
	strNum02		db	"second grasshopper jumps, ",0
	strNum03		db	"third grasshopper jumps, ",0
	strNum04		db	"fourth drinks red wine like a gentleman.",13,10,0
	hello			db	"Hello my name is j00n",13,10,0

; _______________________________________________________________________________
;   uninitialized variables
.data?
	myLength		DWORD	?
	myStrContainer		db MAXSIZE dup(?)
	genelTampon 		db 1024 (?)
