include windows.inc 
include kernel32.inc 
include masm32.inc
include msvcrt.inc
includelib kernel32.lib 
includelib masm32.lib
includelib msvcrt.lib	;olmazsa "inkey" hata veriyor

;masm macrosu     
include \masm32\macros\macros.asm	;olmazsa "inkey" hata veriyor

;prototiplerimiz
ExitProcess PROTO, dwExitCode:dword

.data
; intArray adýnda 10 elemanlý bir dizi tanýmlýyoruz
intArray BYTE 21, 43, 11, 32, 98, 23, 44, 72, 13, 91
ileti1 BYTE "Dizimizin ilk hali: ",13,10,0
ileti2 BYTE "Dizimizin son hali: ",13,10,0
yeniSatir db 13, 10, 0 ;,13,10 yazdýk böylece alt satýra geçmiþ oldu.

.data?
tampon01 db 12 dup(?)
tampon02 db 12 dup(?) 

;crlf: push eax
;mov eax,0Dh ; output a CR
;call StdOut
;mov eax,0Ah ; output an LF
;call StdOut
;pop eax
;ret 
;bununla proc yap dene