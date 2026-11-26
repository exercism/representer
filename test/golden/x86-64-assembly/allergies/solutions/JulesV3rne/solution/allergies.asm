section .text
global allergic_to
allergic_to:
		mov r9, 1
		mov rcx, rdi
		shl r9, cl  	; align bitmask
		and rsi, r9
		cmp r9, rsi
		jne .false
		mov rax, 1
		ret
		.false:
		mov rax, 0
		ret

global list
list:
		push rbx
		xor rcx, rcx
		xor rbx, rbx
		.loopstart:
		mov r9,	1
		and r9, rdi
		jz .skip
		mov dword[rsi+4+rbx*4], ecx
		inc rbx
		.skip:
		inc cl
		shr rdi, 1
		cmp cl, 8
		jl .loopstart
		mov dword[rsi], ebx
		pop rbx
		ret
