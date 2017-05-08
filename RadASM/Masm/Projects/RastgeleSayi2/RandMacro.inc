Rand MACRO rgLow, rgHigh, randDest	; to reg32, byte, word, dword, qword, r4, r8, r10, xmm, f:xmm
LOCAL oa, rgLowD, rgHighD, dot, tmp$, LeaRD, destType
  ifndef MbRndSeed
	.DATA
	align 16			; needs an align 16 to be fast
	MbRndSeed dd "Ciao"
	.CODE
  endif
  ifb <rgLow>
	rdtsc		; Rand(): initialise
	mov MbRndSeed, eax
	EXITM <>
  else
	oa INSTR <rgLow>, <:>	; Rand(seed:ciao)
	if oa eq 5
		tmp$ SUBSTR <rgLow>, 6
		tmp$ CATSTR <mov MbRndSeed, ">, tmp$, <">
		tmp$
		EXITM <>
	endif
  endif
  destType=99			; default
  ifnb <randDest>		; mov MyDwordArray(ecx), Rand(123) uses edx
	destType=ChkNum(randDest)	; ChkNum returns aPass$, may have ?p:
	tmp$ CATSTR <randDest>	; looks horribly complicated
	LeaRD INSTR tmp$, <[>	; but JWasm needs it
	if LeaRD
		lea edx, randDest
		push edx
	endif
  endif
  mov eax, MbRndSeed	; Initial value
  imul eax, -127		; randomise
  add eax, -124		; the magic
  bswap eax			; we need the high order bits
  mov MbRndSeed, eax	; save for next round
  ifb <rgHigh>				; Rand(123): return dword; only integers allowed
	push edx		; mov MyDwordArray(99), Rand(123) uses edx, so we better save it
	oa = (opattr rgLow) AND 127
	if oa eq 36
		if rgLow ge -128 and rgLow le 127
				push rgLow
				pop edx
		else
				mov edx, rgLow	; multiply MbRndSeed
		endif
		mul edx	; with rgLow
	else
		mul rgLow	; multiply MbRndSeed with rgLow
	endif
	xchg eax, edx
	pop edx
	EXITM <eax>	; return random number, leave edx intact for arrays
  endif
  dot INSTR <rgHigh>, <.>
  if dot
	.DATA
	  rgHighD REAL8 rgHigh
	.CODE
	fld rgHighD
  else
	if (opattr rgHigh) eq 36	; immediate integer
			ifidn <rgHigh>, <1>
				fld1
			else
				push rgHigh
				fild stack
				pop edx
			endif
	elseif TYPE(rgHigh) eq DWORD	; global or local dword
			if (opattr rgHigh) eq 48	; register
				push rgHigh
				fild stack
				pop rgHigh
			else
				fild rgHigh
			endif
	else
		fld rgHigh	; REAL var
	endif
  endif
  dot INSTR <rgLow>, <.>
  if dot
	.DATA
	  rgLowD REAL8 rgLow
	.CODE
	fld rgLowD
	fld st
	fsubp st(2), st
	fxch
  elseifdif <rgLow>, <0>
	if (opattr rgLow) eq 36	; immediate integer
			ifidn <rgLow>, <1>
				fld1
			else
				push rgLow
				fild stack
				pop edx
		endif
	elseif TYPE(rgLow) eq DWORD	; global or local dword
			if (opattr rgLow) eq 48	; register
				push rgLow
				fild stack
				pop edx	; correct the stack
			else
				fild rgLow
			endif
	else
		fld rgLow	; REAL var
	endif
	fld st
	fsubp st(2), st
	fxch
  endif
  push 0			; high dword
  or edx, -1		; maybe a simple push eax
  mul edx			; would be enough...?
  push edx		; low dword
  fild qword ptr [esp]
  fmul			; pops ST
  ifndef MbRndMul
	.DATA
	MbRndMul REAL8 2.3283064365387E-010
	.CODE
  endif
  fmul MbRndMul	; no pop
  ifdif <rgLow>, <0>
	fadd	; pops ST
  endif
  ifb <randDest>
	pop edx	; restore correct
	pop edx	; stack count
	EXITM <>	; result in ST
  endif
  if LeaRD		; SIZE ptr [edx]: DWORD includes BYTE and WORD
	if destType eq MbDword or destType eq MbQword
		mov edx, [esp+8]	; get randDest
		fnstcw word ptr [esp]	; save original
		fnstcw word ptr [esp+2]	; plus a copy
		mov byte ptr [esp+1], 0111b	; MbDown64
		fldcw word ptr [esp]	; set new control word
		oa INSTR aPass$, <p:>
		if oa eq 2
			tmp$ SUBSTR aPass$, 1, 3
			ifidni tmp$, <wp:>
				fistp word ptr [edx]
			else
				fistp word ptr [esp]
				mov al, [esp]
				mov [edx], al
			endif
		elseif destType eq MbDword
			fistp dword ptr [edx]
		else
			fistp qword ptr [edx]
		endif
		fldcw word ptr [esp+2]	; set old control word
		pop edx	; restore correct
		pop edx	; stack count
		pop edx	; pushed randDest
	else
		pop edx	; restore correct
		pop edx	; stack count
		pop edx	; pushed randDest
		if destType eq MbReal4
			fstp REAL4 ptr [edx]	; must come after the pops
		elseif destType eq MbReal8
			fstp REAL8 ptr [edx]
		elseif destType eq MbReal10
			fstp REAL10 ptr [edx]
		endif
	endif
  elseif destType eq MbXmmR
	fstp REAL8 ptr [esp]
	tmp$ SUBSTR <randDest>, 3
	movq tmp$, REAL8 ptr [esp]	; movq xmm0, ...
	pop edx			; restore correct
	pop edx			; stack count
  elseif destType eq MbXmmI
	fstp REAL8 ptr [esp]
	movq randDest, qword ptr [esp]
	cvttpd2dq randDest, randDest	; convert with truncation
	pop edx			; restore correct
	pop edx			; stack count
  else
	if destType eq MbDword or destType eq MbQword	; xmm or mem real8
		fnstcw word ptr [esp]	; save original
		fnstcw word ptr [esp+2]	; save a copy
		mov byte ptr [esp+1], 0111b	; MbDown64
		fldcw word ptr [esp]	; set new control word
		fistp randDest
		fldcw word ptr [esp+2]	; set old control word
	else
		fstp randDest
	endif
	pop edx			; restore correct
	pop edx			; stack count
  endif
ENDM
