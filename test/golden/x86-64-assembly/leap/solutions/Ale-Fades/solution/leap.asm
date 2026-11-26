section .text
global leap_year
leap_year:
	test	dil, 3		; only need 2 bits
	jnz		.false		; not divisible by 4
	mov		eax, edi
	xor		edx, edx	; zero out edx instead of cdq
	mov		ebx, 100
	idiv	ebx
	test	edx, edx
	jnz		.true		; not divisible by 100
	mov		eax, edi
	mov		ebx, 400
	idiv	ebx
	test	edx, edx
	jnz		.false		; not divisible by 400
.true:
	mov		eax, 1
	ret
.false:
	xor		eax, eax
	ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
