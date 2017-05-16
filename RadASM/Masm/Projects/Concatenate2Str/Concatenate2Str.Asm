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
; Concatenate2Str MASM32 Sample Code
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: ErrorInside <errorinside@sctzine.com>
; IDE		: RADAssembler v2.2.2.2 <http://masm32.com/board/index.php?board=24.0>
; Taslak	: BlueDeviL // SCT
; Tarih  	: 16.05.2017
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;																  www.sctzine.com
TITLE  [SCT]Concatenate2Str MASM32 Sample Code	 				  (Concatenate2Str.asm)
.386					
.model flat, stdcall	
option casemap :none	


include Concatenate2Str.Inc

.code
start:
	call main
	inkey											;wait before exit
	exit
	
main proc
	invoke SetConsoleTitle,addr konsolBaslik		;title for our console
	invoke ClearScreen								;clear screen?
	print offset sctGS
	
	invoke StdOut, chr$("Let's concatenate strings",13,10)
	;01 I can use lstrcat funtion to concatenate two strings:
	invoke lstrcpy, addr myStrContainer, addr strNum01
	invoke lstrcat, addr myStrContainer, addr strNum02
	invoke lstrcat, addr myStrContainer, addr strNum03
	invoke lstrcat, addr myStrContainer, addr strNum04
	invoke StdOut, addr myStrContainer
	;02 I can use "chr$"
	invoke StdOut, chr$("First half", " ", "and second half",13,10)
	invoke StdOut, chr$("1AC4","-","12FA","-","FE1C")
	;03 I can use other functions inside cat$
	print cat$(chr$(13, 10, "Stack/BP="), str$(esp), chr$("/"), str$(ebp), chr$(13,10))
	invoke StdOut, cat$(chr$(13, 10, "Stack/BP="), str$(esp), chr$("/"), str$(ebp), chr$(13,10))
	;04 I can use add$ to concatenate strings
	mov eax, add$(addr strLine01,addr strLine02)
	invoke StdOut, offset strLine01
	print chr$(13,10)								;newline
	
	invoke StdOut,addr hello
	invoke lstrlen,offset hello
	mov myLength,eax
	;ok this is an unefficient code, but written immediately at work :)
	xor ecx, ecx									;ecx = 0, ecx will be my counter
	_looooop:
	cmp ecx, myLength
	je _loopexit
	xor eax, eax
	movsx eax, byte ptr ds:[ecx+hello]				;eax = only one character of my string
	inc ecx											;increment counter
	cmp al, 30h										;is my character 0 ?
	jne _looooop									;if not equal loop again
	dec ecx
	mov byte ptr ds:[ecx+hello], 45h				;if 0 then change with E
	inc ecx
	cmp ecx, myLength
	jne _looooop
	_loopexit:
	invoke StdOut, addr hello
	;invoke ExitProcess,0
	ret

main endp

end start
