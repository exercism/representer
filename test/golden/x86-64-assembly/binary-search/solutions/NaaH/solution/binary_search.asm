section .text
global find
find:
    ; Provide your implementation here
    ; rdi array
    ; esi size
    ; edx value
    ; return index in eax

    ;check if array is null pointer or length is 0
    push rbx
    test rdi, rdi
    jz fail
    test esi, esi
    jz fail
    ; eax temporary index to return
    ; ecx lower bound
    ; esi upper bound
    xor ecx, ecx
    sub esi, 1

bog:
    ; index to check value -- (ecx+esi)/2
    mov eax, ecx
    add eax, esi
    shr eax, 1

    mov r8d, [rdi + rax*4]
    cmp edx, r8d
    je end
    jl less
    cmp ecx, esi
    je fail

    more:
    mov ecx, eax
    inc ecx
    jmp afterless

    less:
    cmp eax, ecx
    je fail
    mov esi, eax
    dec esi

    afterless:

    jmp bog

    fail:
    mov eax, -1
    end:
    pop rbx
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
