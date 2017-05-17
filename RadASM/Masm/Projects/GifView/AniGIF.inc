; ------------------------------------------------------------------------
;|AniGIF is a copyright of Antonis Kyprianou.                             |
;|                                                                        |
;|You can use AniGIF for NON commercial purposes provided you             |
;|have the following information on your application's about box:         |
;|AniGIF control is copyright of Antonis Kyprianou (http://www.winasm.net)|
;|                                                                        |
;|You need my WRITTEN permission to use AniGIF in commercial applications |
; ------------------------------------------------------------------------

;Proto's
InitAniGIF					PROTO
TerminateAniGIF				PROTO

;AniGIF control Styles
WAGS_AUTOSIZE				EQU	1H
WAGS_CENTER					EQU	2H
WAGS_HYPERLINK				EQU	4H

;AniGIF control messages
WAGM_BASE					EQU WM_USER+1000
WAGM_LOADGIFFROMFILE		EQU WAGM_BASE+0	;wParam:N/A,		lParam:lpFileName
WAGM_LOADGIFFROMRESOURCE	EQU WAGM_BASE+1	;wParam:hInstance,	lParam:ResourceID
WAGM_UNLOADGIF				EQU WAGM_BASE+2	;wParam:N/A,		lParam:N/A
WAGM_SETHYPERLINK			EQU WAGM_BASE+3	;wParam:N/A,		lParam:lpszHyprelink
WAGM_ZOOM					EQU WAGM_BASE+4	;wParam:N/A,		lParam:TRUE(Zoom In by 10%)/FALSE(Zoom Out by 10%)
WAGM_SETBKCOLOR				EQU WAGM_BASE+5	;wParam:N/A,		lParam:BkColor
