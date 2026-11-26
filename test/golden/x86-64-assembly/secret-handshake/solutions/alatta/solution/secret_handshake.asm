default rel

section .rodata
wink: db 'wink, ', 0
blink: db 'double blink, ', 0
close: db 'close your eyes, ', 0
jump: db 'jump, ', 0

section .text
%macro strcopy 0
.loop:
    lodsb
    stosb
    cmp al, 0
    jnz .loop
    dec rdi   ; return pointer to position of null terminator
%endmacro

global commands
commands:
    ; rdi = buffer ptr, rsi = int input
    test sil, 0xF    ; check for no actions (sil=0bxxxx0000)
    jz empty         
    
    mov dl, sil      ; copy sil to dl for forward parse
    lea r8, [wink]   
    lea r9, [blink]
    lea r10, [close]
    lea r11, [jump]

    test sil, 0x10 ; if reversed,
    jz .forward
    
    mov rax, r8    ; reverse ptr order
    mov r8, r11
    mov r11, rax
    mov rax, r9
    mov r9, r10
    mov r10, rax
    
    shr sil, 1     ; and reverse lower 4 bits of input
    rcl dl, 1      ; (how does x86 not have an instruction for this?)
    shr sil, 1
    rcl dl, 1
    shr sil, 1
    rcl dl, 1
    shr sil, 1
    rcl dl, 1
.forward:
    shr dl, 1      ; test bit for each string
    jnc str2    
    mov rsi, r8    ; copy if set
    strcopy
str2:
    shr dl, 1      ; this unrolled method with registers should be fast but its far from compact
    jnc str3
    mov rsi, r9
    strcopy
str3:
    shr dl, 1
    jnc str4
    mov rsi, r10
    strcopy
str4:
    shr dl, 1
    jnc .exit
    mov rsi, r11
    strcopy

.exit:
    mov byte [rdi-2], 0 ; truncate last comma/space
    ret

empty:
    mov byte [rdi], 0
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
