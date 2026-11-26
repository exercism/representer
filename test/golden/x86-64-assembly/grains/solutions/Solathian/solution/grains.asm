section .text
global square

; Define an error value
ERROR_VALUE equ 0

square:
    ; Provide your implementation here
    ;return  pow(2, index - 1);

    ; check if it is negative
    mov rbx, qword 2147483647    ;since it is stored in a 32 bit two complement
    cmp rdi, rbx
    ja .error   

    ; check for 0
    cmp rdi, 0
    je .error

    ; check for >65
    cmp rdi, 64
    ja .error
    
    mov r9, 1   ; r9 will be the counter
    mov rax, 1  

    

    .loop_start:
        cmp r9, rdi
        je .loop_end
        imul rax, rax, 2  ; Multiply by 2
        inc r9
        jmp .loop_start
    .loop_end:
        ret
    .error:
        mov rax, ERROR_VALUE
        ret

global total
total:
    mov rax, 0
    sub rax, 1  ; Subtract 1 from rax, this way int max 64 will be reached
    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
