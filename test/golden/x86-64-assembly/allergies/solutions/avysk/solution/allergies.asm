%define $edi edi
%define $eax eax

section .text
global allergic_to
allergic_to:
    mov         ecx, 1
lp1:
    cmp         edi, 0
    jz          done
    sub         edi, 1
    shl         ecx, 1
    jmp         lp1
done:
    test        esi, ecx
    jnz         allergic
    mov         eax, 0
    ret
allergic:
    mov         eax, 1
    ret

global list
list:
    mov         r8, rsi         ; r8 is pointing to int size field
    mov qword   [r8], 0
    mov         r9, rsi
    add         r9, 4           ; r9 is pointing to the start of the array of
                                ; allergens
    mov         edx, -1         ; allergen to test allergy for
    mov         rsi, rdi        ; the mask to test allergies for
lp2:
    add         edx, 1
    mov         edi, edx
    call        allergic_to     ; test for the given allergen
    cmp         eax, 0
    jz          l               ; if not allergic, skip
    mov         eax, [r8]       ; record the allergy
    inc         eax
    mov         [r8], eax
    mov         [r9], edx
    add         r9, 4
l:  cmp         edx, 7
    jnz         lp2
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
