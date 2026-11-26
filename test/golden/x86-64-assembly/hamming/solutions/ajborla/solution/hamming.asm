; ----------------------------------------------------------------------
; exercism.io
; x86-64-assembly Track Exercise: hamming
; Contributed: Anthony J. Borla (ajborla@bigpond.com)
;
; -------------------
;
; C-callable routine, declared as:
;
;     int distance(const char *strand1, const char *strand2);
;
; Accepts two ASCIIZ strings, 'strand1', and 'strand2', each
; representing a DNA strand, and calculates the hamming distance
; between them.
;
; Note:
;
; - key assumption: identical length strands, else validation fails
; - detection of invalid nucleotide sees the comparison process
;   terminated with return code set to -1
; - hamming distance (as defined here) is the number of differences
;   between the strands; this is the value returned:
;   + 0       : No differences
;   + positive: Number of differences
;   + -1      : Validation failed
;
; -------------------
;
; input:  rdi - const char* strand2
;         rsi - const char* strand1
; return: rax - return code (see header commentary)
; local:  r10 - base address of RDI
;         r11 - base address of RSI
;          al - current character at [RSI]
;          bl - current character at [RDI]
;          bh - last character at [RSI]
;          bl - last character at [RDI]
;         rcx - Hamming Distance
; ----------------------------------------------------------------------
                    default rel

; ---- Code
                    section .text
                    global distance

; ---- Entry point
distance:           ; Save RSI in temporary register, swap RSI and RDI
                    ; so RSI -> strand1, RDI -> strand2
                    mov  r10, rsi
                    push rdi
                    pop  rsi
                    mov  rdi, r10

                    ; Save base address of each sequence
                    ; r10 - base address RDI
                    ; r11 - base address RSI
                    mov  r11, rsi

                    ; Initialise hamming distance counter
                    xor  rcx, rcx

                    ; Set sequence pointers to 1 byte before sequence
                    dec  rsi
                    dec  rdi

scan_seq:           ; Scan both sequences
                    xor  rax, rax
                    xor  rbx, rbx
                    inc  rsi
                    inc  rdi
                    mov  byte al, [rsi]
                    cmp  al, 0
                    je   scan_seq_done
                    mov  byte bl, [rdi]
                    cmp  bl, 0
                    je   scan_seq_done
                    sub  al, bl
                    jz   scan_seq
                    inc  rcx
                    jmp  scan_seq

scan_seq_done:      ; Ready Hamming Distance for return to caller
                    mov  rax, rcx

                    ; Load registers bh and bl with current values of
                    ; [RSI] and [RDI]. Both should contain 0 if the
                    ; sequences are of equal length
                    mov  byte bh, [rsi]
                    mov  byte bl, [rdi]

check_seq_1:        ; Check sequence 1
                    cmp  bh, 0
                    je   check_seq_2
                    jmp  set_seqs_not_equal

check_seq_2:        ; Check sequence 2
                    cmp  bl, 0
                    je   exit

set_seqs_not_equal: ; Unequal length, set return value accordingly
                    mov  rax, -1

exit:               ; Hamming Distance (or error) returned to caller
                    ret

