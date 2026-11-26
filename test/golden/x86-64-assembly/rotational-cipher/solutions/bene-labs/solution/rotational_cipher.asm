section .text
global rotate
rotate:
    xor rcx, rcx
    cmp rdi, 0 ; check if array is valid
    jle .EXIT
    mov r11, rdx ; backup buffer parameter in r11d as rdx is used in operations

    .LOOP:
        xor r10, r10
        mov r10b, BYTE [rdi + rcx]
        cmp r10b, 0 ; is end of array?
        je .EXIT
        
        cmp r10, 65 ; 'A'
        jl .NOT_UPPER
        cmp r10, 90 ; 'Z'
        jle .UPPER_SHIFT

    .NOT_UPPER:
        cmp r10, 97 ; 'a'
        jl .NOT_LETTER
        cmp r10, 122 ; 'z'
        jle .LOWER_SHIFT

    .NOT_LETTER:
    .INCREMENT_LOOP:
        mov BYTE [r11 + rcx], r10b
        inc rcx
        jmp .LOOP

    .UPPER_SHIFT:
        add r10, rsi
        sub r10, 65
    
        movsx rax, r10b ; dividend
        xor rdx, rdx ; stores remainder
        mov rbx, 26 ; divisor
        div rbx ; store result of rax / 26 in rax and remainder in rdx
        movzx r10d, dl ; modulo of 26 can be safely stored as byte
        add r10b, 65 ; add back the base 'A' value to the modulo shift
        jmp .INCREMENT_LOOP

    .LOWER_SHIFT:
        sub r10, 97 ; sub 'a'
        add r10, rsi ; add shift
        
        mov rax, r10 ; dividend
        xor rdx, rdx ; stores remainder
        mov rbx, 26 ; divisor
        div rbx ; store result of rax / 26 in rax and remainder in rdx
        movzx r10d, dl ; modulo of 26 can be safely stored as byte
        add r10b, 97 ; add back the base 'A' value to the modulo shift
        jmp .INCREMENT_LOOP

    .EXIT:
        mov BYTE [r11 + rcx], 0
        ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
