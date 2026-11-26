section .text
global distance
distance:
    xor ecx, ecx
  .loop:
    cmpsb
    ; if different, go to check if any of the strings ended
    ja .check_first_null
    jb .check_second_null
    ; equal character, check if it was 0
    mov al, [rdi-1]
    test al, al
    ; continue until end of strings
    jnz .loop
    mov eax, ecx
    ret
  .check_first_null:
    mov al, [rdi-1]
    test al, al
    jz .different_lengths
  .inc_distance:
    inc ecx
    jmp .loop
  .check_second_null:
    mov al, [rsi-1]
    test al, al
    jnz .inc_distance
  .different_lengths:
    xor eax, eax
    not eax
    ret
