default rel

section .rodata
msg_begin: db "One for ",0
msg_name_def: db "you",0
msg_end: db ", one for me.",0

%macro WriteToBuf 1
    ; %1 is the buffer to write to
    ; The string to print to the buffer is always in rcx
    ; This is a totally unsafe write as it relies on nul terminated strings
    cmp byte [rcx], 0
    je %%end_write
%%write_loop:
    mov al, [rcx]
    mov [%1], al
    inc %1
    inc rcx
    cmp byte [rcx], 0
    jne %%write_loop
%%end_write:
%endmacro

section .text
global two_fer
two_fer:
    ; First two params of function call should be placed in RDI and RSI if we're following C calling conventions
    ; RDI: Name
    ; RSI: Buffer to write to
    lea rcx, [msg_begin]
    WriteToBuf rsi

    ; Check if the name passed is a non-null str pointer
    lea rcx, [msg_name_def]
    ; If a name was passed in then conditionally load it
    test rdi, rdi
    cmovne rcx, rdi
    WriteToBuf rsi

    lea rcx, [msg_end]
    WriteToBuf rsi

    ; Terminate our buffer
    mov byte [rsi], 0

    ret
