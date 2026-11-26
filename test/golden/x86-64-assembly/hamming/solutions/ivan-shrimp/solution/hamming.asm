section .text
global distance

; Strings in `rsi` and `rdi`.
distance:
    xor eax, eax  ; al: for holding the result of `cmp`
    xor r8d, r8d  ; r8: current offset of string
    xor r9d, r9d  ; r9d: Hamming distance
    jmp .begin

.loop:
    cmp dl, cl                 ; Compare the current characters.
    setne al                   ; If they are different,
    add r9d, eax               ; increment the Hamming distance.
.begin:
    movzx edx, byte [rsi + r8] ; Load next byte from the first string.
    movzx ecx, byte [rdi + r8] ; Load next byte from the second string.
    inc r8                     ; Increment the offset.
    test dl, dl                ; Check if the first byte
    setnz al                   ;
    cmp cl, 1                  ; and the second byte are null.
    sbb al, 0                  ; al = (number of non-null bytes among them) - 1
    jg .loop                   ; If al > 0 (i.e. both bytes non-null), continue.

    mov eax, -1    ; If the strings have different lengths, return -1.
    cmovl eax, r9d ; Otherwise, return the Hamming difference.
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
