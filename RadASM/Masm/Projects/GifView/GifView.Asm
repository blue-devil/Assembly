; ЬЮЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЪЮ?
; Ь?кФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФ?Ь?
; Ь?? ммллллллллл   ммлллллллмм   млллллллллм ?Ь?
; Ь?? лллллллллпп   лллллллллпп   плллллллллп ?Ь?
; Ь?? лл            ллп               ллл     ?Ь?
; Ь?? лл            лл                ллл     ?Ь?
; Ь?? лллллллллмм   лл                ллл     ?Ь?
; Ь?? ппллллллллл   лл                ллл     ?Ь?
; Ь??          лл   лл                ллл     ?Ь?
; Ь??          лл   ллм               ллл     ?Ь?
; Ь?? ммллллллллл   лллллллллмм       ллл     ?Ь?
; Ь?? лллллллллпп   пплллллллпп       плп     ?Ь?
; Ь??                                         ?Ь?
; Ь??                home of secret reversersЎ?Ь?
; Ь?УФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФ?Ь?
; [SCT]Gif Viewer with AniGIF Library
; _______________________________________________________________________________
; Yazar		: BlueDeviL <bluedevil@sctzine.com>
; Tester	: Error§nside <errorinside@sctzine.com>
; IDE		: RADAssembler v2.2.2.2 <http://masm32.com/board/index.php?board=24.0>
; Taslak	: BlueDeviL // SCT
; Tarih		: 17/05/2017
; ЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏЏ
;																  www.sctzine.com
.586					
.model flat, stdcall	
option casemap :none	

include GifView.inc

.code

start:

	invoke	GetModuleHandle,NULL
	mov		hInstance,eax
	invoke	LoadCursor,NULL,IDC_HAND
	mov		hImlec,eax
    invoke	InitCommonControls
    
	invoke	DialogBoxParam,hInstance,pencere,NULL,addr PencereIslemi,NULL
	
	invoke	ExitProcess,0

ImlecYukle proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
;change the cursor when mouse over on static
  .if uMsg==WM_SETCURSOR
    invoke SetCursor, hImlec
  .else
    invoke GetWindowLong, hWin, GWL_USERDATA
    invoke CallWindowProc, eax, hWin, uMsg, wParam, lParam
    ret
  .endif

  xor eax, eax
  ret
ImlecYukle endp

PencereIslemi proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	invoke InitAniGIF					;Starts animation
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke LoadIcon,hInstance,5001
		invoke SendMessage,hWin,WM_SETICON,ICON_SMALL,eax
		invoke uFMOD_PlaySong,500,hInstance,XM_RESOURCE	;play music of course

		invoke GetDlgItem,hWin,lblLink
		push eax
		invoke SetWindowLong,eax,GWL_WNDPROC,ADDR ImlecYukle
		pop edx
		invoke SetWindowLong,edx,GWL_USERDATA,eax
		
	.elseif eax==WM_COMMAND
		mov eax,wParam
		mov edx,wParam
		shr edx,16
		
		.if dx==BN_CLICKED
			.if ax==lblLink				;goto  www.sctzine.com
				invoke ShellExecute,hWin,ADDR TarayiciyaGit,ADDR SCTweb,NULL,NULL,0
			.endif
		.endif
		
		.if ax==btnKapat				;Quit
			invoke EndDialog,hWin,0		
			ret
		.endif
		
		.if ax==btnHakkinda				;About
			invoke MessageBox,hWin,ADDR msgHakkinda,ADDR msgBaslik,MB_OK
			ret
		.endif
	.elseif eax==WM_CLOSE
		invoke uFMOD_PlaySong,0,0,0
		invoke  EndDialog, hWin, 0
	.else
		mov		eax,FALSE
		ret
	.endif
	invoke TerminateAniGIF				;HERE terminates animation
	mov		eax,TRUE
	ret

PencereIslemi endp

end start
