default rel

section .text
global two_fer
two_fer:
    ; Provide your implementation here
    lea rax, [prefix] ;load prefix to rax
    call load_into_buffer ;load "One for " to buffer

    lea rax, [rdi] ;load Input to rax
    cmp rax, 0 ;check if input is null
    jne .not_null ;if input is not null
    lea rax, [defName]
    .not_null:
    call load_into_buffer
    
    lea rax, [postfix]
    call load_into_buffer
    ret

load_into_buffer: ;; load string to buffer
.loop:
  mov dl, byte [rax]
  mov byte [rsi], dl
  inc rax 
  inc rsi 
  cmp dl, 0
  jnz .loop
  dec rsi ;make rsi point back to the '\0'
  ret
section .rodata
prefix: db "One for ", 0
defName: db "you", 0
postfix: db ", one for me.", 0