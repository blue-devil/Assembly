;fonksiyon tan�m dosyalar�
include windows.inc					;windows.inc her zaman en �stte

include user32.inc
include masm32.inc
include msvcrt.inc
include kernel32.inc

;masm32 makrolar�
include \masm32\macros\macros.asm

;fonksiyonlar�n kendilerinin bulundu�u k�t�phaneler
includelib masm32.lib
includelib user32.lib
includelib msvcrt.lib
includelib kernel32.lib

;sabitler
.const
BELLEKALANI				equ 65535

;de�i�kenlerimiz
.data
sctGS					db  "        �����������������������������������������������������������������Ŀ",13,10
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
konsolBaslik			db	"[SCT]CreateFile ReadFile WriteFile Uygulamasi 2",0 
dosyaYolu				db	"C:\createfileornek.txt",0
dosyaMetin				db	"Dosya icine yazilacak yazi.",13,10,0

;i�eri�i tan�mlanmam�� de�i�kenler
.data?
hDosya					dd	?
hBellek					dd	?
NumOfBytesRead			dd	?
NumOfBytesWritten		dd	?
dosyaOkunan				dd	?