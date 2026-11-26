section .text

; void rotate(const char *text, int shift_key, char *buffer);
;                          rdi            rsi           rdx
global rotate
rotate:
    ; Compute (rsi mod 26) ensure 0 <= rsi <= 25
    mov rcx, rdx              ; Backup rdx as we need to clear it for div
    xor rdx, rdx              ; Prepare dividend rdx:rax
    mov rax, rsi              ;
    mov rbx, 26               ; Prepare divisor
    div rbx                   ; rdx:rax / rbx --> quotient: rax, remainder: rdx
    mov rsi, rdx              ; Save (shift_key % 26) to rsi
    mov rdx, rcx              ; Restore rdx

.start:
    mov al, [rdi]             ; Load char to al

.check_lower_case:
    cmp al, 'a'               ; Check if 'a' <= al <= 'z'
    jb .check_upper_case
    cmp al, 'z'
    ja .check_upper_case
.convert_lower_case:
    add rax, rsi              ; Shift char
    cmp al, 'z'               ; Check if char needs wrap around
    jbe .next
    sub al, 26                ; Wrap around ('z'+1 -> 'a', 'z'+2 -> 'b', .etc.)
    jmp .next

.check_upper_case:
    cmp al, 'A'               ; Check if 'A' <= al <= 'B'
    jb .next
    cmp al, 'Z'
    ja .next
.convert_upper_case:
    add rax, rsi              ; Shift char
    cmp al, 'Z'               ; Check if char needs wrap around
    jbe .next                 ; Need to use unsigned unsigned comparison (jbe)
                              ; because the shifted char might exceed 127
    sub al, 26                ; Wrap around ('Z'+1 -> 'A', 'Z'+2 -> 'B', .etc.)

.next:
    mov [rdx], al             ; Write converted char to buffer

    test al, al               ; Check if we reach '\0'
    jz .end

    inc rdi                   ; Increment text and buffer pointers
    inc rdx
    jmp .start

.end:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
