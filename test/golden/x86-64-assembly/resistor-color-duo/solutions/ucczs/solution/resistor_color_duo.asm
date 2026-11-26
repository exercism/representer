section .text
global value
value:
    mov rax, rdi
    xor r11, r11
    call calculate_ascii_value
first_color_done:
    mov rax, 0xa
    mul r10
    mov r11, rax
    mov rax, rsi
    call calculate_ascii_value
second_color_done:
    add r11, r10
    mov rax, r11
    ret

calculate_ascii_value:
    xor r8, r8
    xor rdx, rdx
iterate_over_chars:
    mov dl, [rax]
    cmp dl, 0
    je get_color_value
    add r8, rdx
    inc rax
    jmp iterate_over_chars
get_color_value:
    mov r10, 0
    cmp r8, 509 ; black
    je return
    mov r10, 6
    cmp r8, 424 ; blue
    je return
    mov r10, 1
    cmp r8, 552 ; brown
    je return
    mov r10, 5
    cmp r8, 529 ; green
    je return
    mov r10, 8
    cmp r8, 439 ; grey
    je return
    mov r10, 3
    cmp r8, 636 ; orange
    je return
    mov r10, 2
    cmp r8, 315 ; red
    je return
    mov r10, 7
    cmp r8, 659 ; violet
    je return
    mov r10, 9
    cmp r8, 545 ; white
    je return
    mov r10, 4
    cmp r8, 668 ; yellow
    je return
return:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
