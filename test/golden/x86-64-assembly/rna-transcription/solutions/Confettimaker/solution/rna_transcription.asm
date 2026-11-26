section .text

global to_rna

;   A : 0x41 -> 0x55 : U
;   C : 0x43 -> 0x47 : G
;   G : 0x47 -> ox43 : C
;   T : 0x54 -> 0x41 : A
;   U : 0x55

to_rna:
    lea rax, [rdi]                ;  Move DNA strand into rax
    dec rsi                       ;  Decrement rsi so that the code can be condensedto have one
.top:                             ;  incrementation of rsi at the beginning of .top rather than in each labeled section (.A, .C, etc.)
    inc rsi                       ;  Increment rsi
    mov dl, byte [rax]            ;  Load first byte of rax into dl
    inc rax                       ;  Increment rax to next byte
    cmp dl, 0x41                  ;  Compare byte to char "A"
    je .A                         ;  If it is "A", jump to the code that handles it
    cmp dl, 0x43                  ;  Compare byte to char "C"
    je .C                         ;  If it is "C", jump to the code that handles it
    cmp dl, 0x47                  ;  Compare byte to char "G"
    je .G                         ;  If it is "G", jump to the code that handles it
    cmp dl, 0x54                  ;  Compare byte to char "T"
    je .T                         ;  If it is "T", jump to the code that handles it
    mov byte [rsi], 0x00          ;  None of the previous comparisons passed, so in this testing environment, we can assume it is NULL
    ret                           ;  Return exectution to _start

.A:
    mov byte [rsi], 0x55          ;  Load "U" into caller's buffer
    jmp .top                      ;  Jump back to .top

.C:
    mov byte [rsi], 0x47          ;  Load "G" into caller's buffer
    jmp .top                      ;  Jump back to .top

.G:
    mov byte [rsi], 0x43          ;  Load "C" into caller's buffer
    jmp .top                      ;  Jump back to .top

.T:
    mov byte [rsi], 0x41          ;  Load "A" into caller's buffer
    jmp .top                      ;  Jump back to .top
