;fonksiyon tan�m dosyalar�
include windows.inc					;windows.inc her zaman en �stte

include masm32.inc
include user32.inc
include msvcrt.inc
include kernel32.inc

;masm32 makrolar�
include \masm32\macros\macros.asm

;fonksiyonlar�n kendilerinin bulundu�u k�t�phaneler
includelib masm32.lib
includelib user32.lib
includelib msvcrt.lib
includelib kernel32.lib

;prototipler
subStrBirlestir			PROTO	:ptr,:ptr,:ptr
subStrYerDegistir		PROTO	:ptr,:ptr,:ptr,:ptr

;sabitler
.const

;de�i�kenlerimiz
.data
	sctGS				db  "        �����������������������������������������������������������������Ŀ",13,10
						db	"      ���                                                                 �Ŀ",13,10
						db	"      �       ����������������             ������         �����������������ܳ",13,10
						db	"      �     ���������   ���������       ���������������   �����������������߳",13,10
						db	"      �     ���������   ���������     ��������   �������        ������      �",13,10
						db	"      �    ���������    ���������     �������    �������         ����       �",13,10
						db	"      �    ���������  �����������    ��������    ��������        ����       �",13,10
						db	"      �     ��������         ����    ��������    �������         ����       �",13,10
						db	"      �       �������                �������   ���               ����       �",13,10
						db	"      �       ���������������        �������                     ����       �",13,10
						db	"      �    ��       ������������     �������         ����        ����       �",13,10
						db	"      �    ���������     �������     �������   ���������         ����       �",13,10
						db	"      �    ���������     ��������    ��������    �������         ����       �",13,10
						db	"      �    ���������     �������      �������    �������         ����       �",13,10
						db	"      �    ��������      �������      �������    ������          ����       �",13,10
						db	"      �      �����������������          ��������������           ����       �",13,10
						db	"      �          ������                   �����                  ����       �",13,10
						db	"      �                                                                     �",13,10
						db	"      �             �����������������������������������������               �",13,10
						db	"      �                  g u r u r l a     s u n a r                        �",13,10
						db	"      �             �����������������������������������������               �",13,10
						db	"      �Ŀ                                                 www.sctzine.com ���",13,10
						db	"        �������������������������������������������������������������������",13,10,0
	konsolBaslik		db	"[SCT]RadASM Konsol Uygulamasi Taslagi ",0 
	strBulunacak		db	"metin",0
	strDegistirilecek	db	"dizi",0
	strBirinci			db	"ilk metin",0
	strIkinci			db	"ikinci metin",0
	strBirlesmis		db	sizeof strBirinci + sizeof strIkinci +1 dup(0)
	strYerDegismis		db	$-strBirlesmis + sizeof strDegistirilecek - sizeof strBulunacak dup(0)
	
	
;verib�y�kl��� belli olmayan de�i�kenler
.data?
	genelTampon 		db 1024 (?)
