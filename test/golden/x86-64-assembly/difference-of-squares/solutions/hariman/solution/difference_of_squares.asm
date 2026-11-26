section .text
global square_of_sum
square_of_sum:
	;; n (n+1) / 2
	mov rax, rdi				; n
	inc rdi						; n+1
	mul rdi						; n (n+1)
	shr rax, 1					; n (n+1) / 2
	mul rax
    ret

global sum_of_squares
sum_of_squares:
	;; n (n+1) (2n+1) / 6
	xor rcx, rcx
    mov rax, rdi
	shl rax, 1					; 2n
	inc rax						; 2n+1
	mul rdi						; n (2n+1)
	inc rdi
	mul rdi						; n (2n+1) (n+1)
	mov cl, 6
	div rcx
    ret

global difference_of_squares
difference_of_squares:
    push rdi
	call sum_of_squares
	mov r8, rax
	pop rdi
	call square_of_sum
	sub rax, r8
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
