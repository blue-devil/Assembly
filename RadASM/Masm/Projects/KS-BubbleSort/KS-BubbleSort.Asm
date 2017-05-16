.386 
.model flat, stdcall 
option casemap :none 

include KS-BubbleSort.inc

.code 
start: 
invoke StdOut, addr ileti1			;ekrana dizimizin ilk hali yazdýrýyoruz
xor esi, esi
xor eax, eax
xor ebx, ebx
xor ecx, ecx
mov ecx, LENGTHOF intArray
mov ebx, 11
_yazdir0 :
mov al, [intArray + esi]
invoke dwtoa, eax, addr tampon01	;dwtoa ile eax yazmacýnda ne yazýyorsa onu belirlediðimiz tampon deðiþkene attýk
invoke StdOut, addr tampon01
invoke StdOut, addr yeniSatir

dec ebx
mov ecx, ebx
inc esi
loop _yazdir0
;_________________________________________
;þimdi kabarcýk algoritmamýzý yazdýralým:
xor eax,eax
xor ecx,ecx
; LENGHTOF ile dizinin boyunu alabiliyoruz
mov ecx, 9; LENGTHOF intArray

_disDongu:
xor ebx, ebx					;yazmacýn birtanesini tampon olarak kullanmak için sýfýrlýyoruz

_icDongu:
mov al, [intArray + bx]; dizinin ilk elemanýný al, ebx arttýkça da sýradaki elemaný al
cmp al, [intArray + bx + 1]; al ile dizinin sýradaki elemanýný karþýlaþtýr
jb _degistirme; eðer ikinci eleman ilkinden büyükse sayacý artýrýp diðer dizi elemanýna geçmek üzere dallan

mov ah, [intArray + bx + 1];dallanma olmazsa buraya geliyor 
mov[intArray + bx + 1], al
mov[intArray + bx], ah


_degistirme:
inc bx
cmp bx, 9
jne _icDongu
loop _disDongu
;__________________________________________
;Dizimizin son halini yazdýralým:
mov edx, offset ileti2
invoke StdOut, addr ileti2
xor esi, esi
xor eax, eax
xor ebx, ebx
xor ecx, ecx
mov ecx, LENGTHOF intArray
mov ebx, 11
_yazdir :
mov al, [intArray + esi]
invoke dwtoa, eax, addr tampon01
invoke StdOut, addr tampon01
invoke StdOut, addr yeniSatir
dec ebx
mov ecx, ebx
inc esi
loop _yazdir
        
inkey	"Devam Etmek icin bir tusa basin!";Press any key to continue yazdýrmak için gerekli.
invoke ExitProcess, 0

end start