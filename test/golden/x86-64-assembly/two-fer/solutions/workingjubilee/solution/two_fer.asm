default rel

%define start           'One for '
%strlen startct         start
%define you             'you'
%strlen youct           you
%define end             ', one for me.'
%strlen endct           end

section .rodata
start_txt:              db start, 0
you_txt:                db you, 0
end_txt:                db end, 0, 0, 0


section .text
global two_fer
two_fer:
        mov r8, rsi             ; r8 becomes a pointer into the stack
        lea rsi, [start_txt]    ; to allow using rsi for lods
        lodsq                   ; Exactly eight bytes
        mov [r8], rax
        add r8, startct
        cmp rdi, 0              ; rdi is null -> no name given
        je .nameless
        mov rsi, rdi

.name:
        lodsb                   ; names have dynamic lengths, so read 1 byte/time
        cmp al, 0               ; in order to find a null terminator
        je .end                 ; and escape
        mov [r8], al
        inc r8
        jmp .name               ; otherwise loop

.nameless:
        lea rsi, [you_txt]
        lodsd                   ; we read in 4 bytes
        mov [r8], rax
        add r8, youct           ; and move to overwrite the null

.end:
        lea rsi, [end_txt]      ; More than 8 bytes
        lodsq
        mov [r8], rax
        add r8, 8               ; since 8 bytes
        lodsq                   ; end_txt needs the null padding for this
        mov [r8], rax
        ret