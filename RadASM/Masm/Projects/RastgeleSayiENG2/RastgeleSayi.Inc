;fonksiyon taným dosyalarý
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include gdi32.inc
include masm32.inc		;need for nseed and nrandom
include advapi32.inc	;need for CryptGenRandom() func.
include Irvine32Mb.inc	;need for Randomize and Random32 func.
include RandMacro.inc

;fonksiyonlarýn kendilerinin bulunduðu kütüphaneler
includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
includelib gdi32.lib
includelib masm32.lib
includelib advapi32.lib
includelib irvine32Mb.lib


;prototipler
DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM;diyalog iþlemi prototipi
ImlecYukle		PROTO	:HWND,:UINT,:WPARAM,:LPARAM;imleçyükle iþlemi prototipi ile linke imleç yüklüyoruz
SerialUret		PROTO	:DWORD
RastGele1		PROTO	:DWORD
RastGele2		PROTO	:DWORD
RastGele3		PROTO	:DWORD
RastGele4		PROTO	:DWORD
RastGele5		PROTO	:DWORD
RastGele6		PROTO	:DWORD
RastGele7		PROTO	:DWORD

;sabitler
.const
pencere			equ 101
ikon			equ 5001

edtGTC			equ 1002
edtRDTSC		equ 1003
edtNRANDOM		equ 1012
edtBirOn		equ 1010
btnUret			equ 1006
btnHakkinda		equ 1007
btnCikis		equ 1008
lblLINK			equ 1009
lblBirOn		equ 1005
edtCryptGenRnd	equ 1011
edtIrvine32		equ 1015
edtIrvine322	equ 1017
edtRand			equ 1021



;deðiþkenlerimiz
.data
msgBaslik		db "About",0
msgHakkinda		db "Random Generator v0.3",13,10,13,10
				db "Generating Random Numbers by GetTickCount API:",13,10
				db "GetTickCount retrieves the number of milliseconds that have elapsed sin",13,10
				db "ce the system was started, up to 49.7 days.The return value is the num",13,10
				db "ber of milliseconds that have elapsed since the system was started.",13,10,13,10
				db "Generating Random Numbers by RDTSC(Time Stamp Counter):",13,10,13,10
				db "This instruction comes with pentium processors and it return the ",13,10
				db "processors cycle to us.Uses 64 bit registers. It writes the most significant",13,10
				db "32 bit to EDX register and writes least significant register to EAX register.",13,10
				db "RDTSC doesnt give us the value of time, it return the prcessors cycle value.",13,10,13,10
				db "Generating Random Numbers by nrandom Func.:",13,10
				db "MASM32.lib containd these functions. Fast and useful. nseed function provides",13,10
				db "nrandom function to make random numbers o every call.",13,10,13,10
				db "Generating Random Numbers by CryptGenRandom API:",13,10
				db "The CryptGenRandom function fills a buffer with cryptographically random bytes.",13,10
				db "To generate these random bytes it uses returnin value forum CryptAcquireContext",13,10
				db "API. To use these API advapi32 library should bu included!",13,10,13,10
				db "Generating Random Numbers by Irvine32Mb library:",13,10
				db "Irvine32Mb kütülibrary contains Randomize,Random32 ve RandomRange functions.",13,10
				db "Random32 func. generates 32bit random numbers. And RandomRange can produce ",13,10
				db "random integer in specified range.",13,10,13,10
				db "Generating Random Numbers by Rand() Function:",13,10
				db "I have exported Rand() function from MasmBasic.inc, it generates integers",13,10
				db "up the limit you specify in the paranthesis. Simple and fast usage.See source!",13,10,13,10
				db "Author:",9,"BlueDeviL // SCT",13,10
				db "Date:",9,"24.10.2012",13,10
				db "E-mail:",9,"bluedevil@sctzine.com",13,10,13,10
				db "Thanks:",13,10
				db "MDK & MASM32 forums, Infexia, jj2007",13,10
				db "[SCT] 2012",0
				
TarayiciyaGit  	db "open", 0
SCTweb			db "http://www.sctzine.com/",0
format			db "%u",0


;veribüyüklüðü belli olmayan deðiþkenler
.data?

hInstance			dd ?;penceremizin handle'ý
hIkon				dd ?;ikonumuzun handle'ý
hSerial				dd ?;serialimizin handle'ý
hImlec				dd ?;linke yüklediðimiz imlecin handle'ý
hPrv				dd ?;Crypt* APIleri için handle

milisaniye			db ?;GetTickCount APIsinden dönen deðeri buna yazdýrýyoruz
rastsayi			dd ?
rastsayi2			dd ?
rastsayi3			db ?
rastsayi4			dd ?;**try this with db and dw !!!***
rastsayi5			dd ?
rastsayi6			dd ?
rastsayi7			dd ?

;#########################################################################
