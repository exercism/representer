; rdi -> item
; rsi -> score
section .text
global allergic_to
allergic_to:
    ; mov rax, 1
    ; shlx rax, rax, rdi
    ; and rax, rsi
    xor rax, rax
    bt esi, edi
    setc al
    ret

; rdi -> score
; rsi -> item_list (int size, items[])
global list
list:
    mov rcx, rsi
    xor rdx, rdx ; size = 0
    mov rsi, rdi ; score=arg0[:8]
    xor rdi, rdi ; curr=0

.loop:
    call allergic_to
    test al, al
    jz .inc_ops
    mov [rcx+rdx*4 + 4], edi
    inc edx
.inc_ops:
    inc edi ; curr++
    cmp edi, 8
    jl .loop

.endlist:
    mov [rcx], edx

    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
