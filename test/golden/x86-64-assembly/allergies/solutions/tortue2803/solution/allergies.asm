section .text
; abi calling convention rdi, rsi, rdx, rcx, r8, r9.

global allergic_to

; input: rdi ~ item like egg, rsi ~ allergy score
; output: return 0 if non-allergic otherwise != 0
allergic_to:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi
        
    mov rax, 1
    mov rcx, rdi
    shl rax, cl ; crazy just shl variable with cl register :=)
    and rax, rsi

    pop rdi
    pop rsi
    mov rsp, rbp
    pop rbp
    ret

; input: rdi ~ scores, rsi ~ list allergic items (output)
global list
list:
    push rbp
    mov rbp, rsp

    mov r8, rsi   ; store rsi to rbx, address of list_item
    lea rdx, [rsi + 4] ; address of items list->items

    mov ebx, 0
    mov [r8], ebx ; list->size = 0

    ; prepare to call allergic_to with rdi = item, rsi = score
    mov rsi, rdi
    mov rdi, 0
loop:
    call allergic_to
    cmp rax, 0 ; cmp rax, 1 WRONG HERE at FIRST, Dangerous C with 0 = false otherwise = true
    jne found
check:
    inc rdi
    cmp rdi, MAX_ITEMS
    je exit    
    jmp loop
found:
    mov ebx, [r8] ; ebx = list->size
    inc ebx
    mov [r8], ebx ; list->size++

    mov [rdx], edi  ; list->items[i] = item
    add rdx, 4      ; i++, enum size is 4 :=)
    jmp check

exit:    
    mov rsp, rbp
    pop rbp
    ret

MAX_ITEMS: equ 8

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
