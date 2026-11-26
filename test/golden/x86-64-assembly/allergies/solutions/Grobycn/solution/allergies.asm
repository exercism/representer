section .text
global allergic_to
allergic_to:
    ; Provide your implementation here

		mov rcx, rdi
		mov rax, 1
		shl rax, cl
		and rax, rsi
    ret

global list
list:
    ; Provide your implementation here
		; rdi - score; rsi - *list

		xor rcx, rcx
		xor r8, r8

.loop:
		cmp rcx, 8
		jge .endloop

		mov rax, 1
		shl rax, cl
		test rdi, rax
		je .notallgeric

		mov [rsi+r8*4+4], ecx
		inc r8

.notallgeric:
		inc rcx
		jmp .loop

.endloop:
		mov [rsi], r8d
    ret
