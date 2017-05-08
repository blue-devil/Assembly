;fonksiyon taným dosyalarý
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include gdi32.inc
include masm32.inc		;nseed ve nrandom iþlemlerinin buradan çaðýrýyoruz
include fpu.inc
include uxtheme.inc


;fonksiyonlarýn kendilerinin bulunduðu kütüphaneler
includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
includelib gdi32.lib
includelib masm32.lib
includelib fpu.lib
includelib uxtheme.lib


;prototipler
PencereIslemi	PROTO	:HWND,:UINT,:WPARAM,:LPARAM;diyalog iþlemi prototipi
ImlecYukle		PROTO	:HWND,:UINT,:WPARAM,:LPARAM;imleçyükle iþlemi prototipi ile linke imleç yüklüyoruz
RassalReelUret	PROTO	:DWORD
Rastgele01		PROTO	:DWORD
Rastgele110		PROTO	:DWORD

;sabitler
.const
pencere			equ 101
ikon			equ 5001

lst0dan1e		equ 1003
lst1den10a		equ 1004
btnKapat		equ 1005
btnHakkinda		equ 1006
btnUret			equ 1007
lblLINK			equ 1008

;deðiþkenlerimiz
.data
msgBaslik		db "About",0
msgHakkinda		db "Random Real Number Generator",13,10,13,10
				db "Generating Random Numbers by RDTSC(Time Stamp Counter):",13,10,13,10
				db "This instruction comes with pentium processors and it return the ",13,10
				db "processors cycle to us.Uses 64 bit registers. It writes the most significant",13,10
				db "32 bit to EDX register and writes least significant register to EAX register.",13,10
				db "RDTSC doesnt give us the value of time, it return the prcessors cycle value.",13,10,13,10
				db "Generating Random Numbers by nrandom function:",13,10,13,10
				db "This function is in the MASM library. It is fast and useful.",13,10
				db "We use nseed for nrandom to generate different numbers each time.",13,10,13,10
				db "FPU Instructions:",13,10,13,10
				db "I used the FPU instruction 'fldpi' to get the number PI. I used",13,10
				db "this number and a random integer to make a random real number.",13,10
				db "You can also use the constant 'e' by using fldl2e but it is not obligatory.",13,10
				db "You can assign a real number to a variable and then use it to make a random",13,10
				db "real number. It is up to you. Finally you can find more information",13,10
				db "about FPU by searching Raymond Filiatreault on the net.",13,10,13,10
				db "Author:",9,"BlueDeviL // SCT",13,10
				db "Date:",9,"04.08.2012",13,10
				db "E-Mail:",9,"bluedevil@sctzine.com",13,10,13,10
				db "Thanks/Greetz",13,10
				db "MASM32 Forums,My old notebook 'Antique'",13,10
				db "[SCT] 2012",0
				
TarayiciyaGit  	db "open", 0
SCTweb			db "http://www.sctzine.com/",0
format			db "%u",0

tampon2			dd 345d
on				db 10d
.data?

hInstance			dd ?;penceremizin handle'ý
hIkon				dd ?;ikonumuzun handle'ý
hListeKutusu		dd ?;serialimizin handle'ý
hListeKutusu2		dd ?;serialimizin handle'ý
hImlec				dd ?;linke yüklediðimiz imlecin handle'ý

rastsayi			dd ?
tampon				db ?
tampon3				db ?

;#########################################################################
