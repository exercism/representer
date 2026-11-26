; Series Slices implementation for x86-64
; Returns: Number of slices or error code

EMPTY_SERIES     equ -1
ZERO_LENGTH      equ -2
NEGATIVE_LENGTH  equ -3
EXCESSIVE_LENGTH equ -4
SLICE_SIZE       equ 20

section .text
global slices

; int64_t slices(char buffer[][SLICE_SIZE], const char *series, size_t slice_length)
; Arguments:
; rdi: buffer (ptr to array of strings)
; rsi: series (ptr to input digits string)
; rdx: slice_length (size_t)
slices:
	; Prologue: Save callee-saved registers
	push rbx
	push r12
	push r13
	push r14
	push r15

	; Store arguments in preserved registers
	mov r12, rdi    ; r12 = buffer base
	mov r13, rsi    ; r13 = series pointer
	mov r14, rdx    ; r14 = slice_length

	; 1. Validate slice_length is not zero
	test r14, r14
	jz .err_zero_len

	; 2. Validate slice_length is not negative (interpreted as signed)
	; size_t is unsigned, but the test passes -1 which becomes a huge positive value.
	; We treat it as signed for the specific error code return.
	cmp r14, 0
	jl .err_neg_len

	; 3. Check if series is empty and find its length
	xor r15, r15    ; r15 = string length counter
.len_loop:
	movzx eax, byte [r13 + r15]
	test al, al
	jz .len_done
	inc r15
	jmp .len_loop

.len_done:
	; Empty series check
	test r15, r15
	jz .err_empty_series

	; 4. Validate slice_length against series length
	cmp r14, r15
	ja .err_excessive_len

	; 5. Calculate number of slices: count = string_len - slice_len + 1
	mov rax, r15
	sub rax, r14
	inc rax
	mov rbx, rax    ; rbx = total slices to extract

	; 6. Extraction Loop
	xor rcx, rcx    ; rcx = i (outer index for slice start)
.outer_loop:
	cmp rcx, rbx
	jae .success_exit

	; Calculate address of buffer[i]: r12 + i * SLICE_SIZE
	imul rax, rcx, SLICE_SIZE
	lea rdi, [r12 + rax]

	; Copy loop
	xor rdx, rdx    ; rdx = j (inner index for character within slice)
.inner_loop:
	cmp rdx, r14
	jae .inner_done
	
	; char = series[i + j]
	mov r8, rcx
	add r8, rdx
	mov al, [r13 + r8]
	mov [rdi + rdx], al

	inc rdx
	jmp .inner_loop

.inner_done:
	; Null-terminate the slice in the buffer
	mov byte [rdi + rdx], 0
	
	inc rcx
	jmp .outer_loop

.success_exit:
	mov rax, rbx    ; Return number of slices
	jmp .exit

.err_empty_series:
	mov rax, EMPTY_SERIES
	jmp .exit

.err_zero_len:
	mov rax, ZERO_LENGTH
	jmp .exit

.err_neg_len:
	mov rax, NEGATIVE_LENGTH
	jmp .exit

.err_excessive_len:
	mov rax, EXCESSIVE_LENGTH

.exit:
	; Epilogue: Restore registers
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif