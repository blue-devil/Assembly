include windows.inc
include user32.inc
include kernel32.inc
include comctl32.inc
include comdlg32.inc
include shell32.inc
include advapi32.inc
Include AniGIF.inc
include ufmod.inc

include \masm32\macros\macros.asm

includelib winmm.lib
includelib user32.lib
includelib kernel32.lib
includelib comctl32.lib
includelib comdlg32.lib
includelib shell32.lib
includelib advapi32.lib
IncludeLib AniGIF.lib
includelib ufmod.lib

PencereIslemi			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
ImlecYukle				PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const
pencere				equ 101
muzik				equ 500
logoGif				equ	501
MAXSIZE				equ	512

grpAdSerial			equ 1002
lblLink				equ 1007
btnKapat			equ 1008
btnHakkinda			equ 1009
aniLogo				equ	1012


PUBLIC hInstance

.data
msgBaslik		db "About",0
msgHakkinda		db "[SCT]Gif Viewer with AniGIF Library",13,10,13,10
				db "Esen! - Hello!",13,10
				db "This small application views GIFs",13,10
				db "And uses AniGIF library to do that.",13,10,13,10
				db "Properties:",13,10
				db "uFMod Music, Animated GIF.",13,10,13,10
				db "Yazan:",9,"BlueDeviL // SCT",13,10
				db "Tester:",9,"Rnd0M // Decompile.us",13,10
				db "Date:",9,"17.05.2017",13,10
				db "E-Mail:",9,"bluedevil@sctzine.com",13,10,13,10
				db "Thanks",13,10
				db "Errorinside, Infexia, Yakuter, Rnd0M",13,10
				db "[SCT] 2017",0

TarayiciyaGit  	db "open", 0
SCTweb			db "http://www.sctzine.com/",0

.data?
hInstance		dd ?
hImlec			dd ?

