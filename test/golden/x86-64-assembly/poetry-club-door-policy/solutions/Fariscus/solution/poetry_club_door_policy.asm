; Everything that comes after a semicolon (;) is a comment.

section .text

; You should implement functions in the .text section.
; A skeleton is provided for the first function.

; the global directive makes a function visible to the test files.
global front_door_response
front_door_response:
    movzx eax, byte [rdi]
    ret

global front_door_password
front_door_password:
    and byte [rdi], ~0x20
    jmp .next
.repeat:
    or al, 0x20
    mov byte [rdi], al
.next:
    inc rdi
    movzx eax, byte [rdi]
    test al, al
    jnz .repeat
    ret

global back_door_response
back_door_response:
    movzx eax, byte [rdi]
    jmp .next
.repeat:
    lea ecx, [rdx - 'A']
    and ecx, ~0x20
    cmp ecx, 'Z'
    cmovbe eax, edx
.next:
    inc rdi
    movzx edx, byte [rdi]
    test dl, dl
    jnz .repeat
    ret

global back_door_password
back_door_password:
    xor ecx, ecx
    movzx eax, byte [rsi]
    and al, ~0x20
.repeat:
    mov byte [rdi + rcx], al
    inc ecx
    movzx eax, byte [rsi + rcx]
    test al, al
    jnz .repeat
    add rdi, rcx
    mov rcx, ", please"
    mov [rdi], rcx
    mov word [rdi + 8], '.'
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
