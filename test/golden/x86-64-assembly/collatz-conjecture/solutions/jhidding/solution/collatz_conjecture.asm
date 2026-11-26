section .text
global steps

; solution improved (read copied) after studying 0x28's solution

steps:
    xor rax, rax             ; Set counter to 0
    test edi, edi	     ; trick to compare against 0
    jng error
loop:
    cmp rdi, 1               ; If DI = 1
    je  complete             ;     return AX
    inc rax
    bt  rdi, 0               ; inspect first bit
    jc  isodd
iseven:
    shr rdi, 1               ; BX = BX/2
    jmp loop
isodd:
    lea rdi, [rdi*3 + 1]     ; a single instruction !?!
    jmp loop
complete:
    ret
error:
    mov rax, -1
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
