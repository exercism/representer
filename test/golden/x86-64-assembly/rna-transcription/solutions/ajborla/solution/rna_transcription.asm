; ----------------------------------------------------------------------
; exercism.io
; x86-64-assembly Track Exercise: rna_transcription
; Contributed: Anthony J. Borla (ajborla@bigpond.com)
;
; -------------------
;
; C-callable routine, declared as:
;
;     void to_rna(const char *strand, char *buffer);
;
; Accepts an ASCIIZ string, 'strand', representing a DNA sequence, and
; converts it to its corresponding RNA sequence storing this in the
; location, 'buffer'.
;
; Note:
;
; - performs data validation; when invalid nucleotides recognised,
;   the transcription process is terminated, return string NUL'd, and
;   ordinarily, a return code would be set, but here nothing is done
;
; - transcription rules:
;
;   DNA  ->  RNA
;   ---      ---
;   'A'      'U'
;   'C'      'G'
;   'G'      'C'
;   'T'      'A'
;
; - a '-' character is copied when ta non-DNA input character present
;
; -------------------
;
; input:  rdi - const char* strand, a string literal representing a DNA
;               sequence
;         rsi - char* buffer, output buffer
; return: N/A
; local:  r10 - lookup table base address
;          al - table index
;          bl - table value
; ----------------------------------------------------------------------
                    default rel

; ---- Read-only data
                    section .rodata

                    ; DNA -> RNA Transcription Table
dna_2_rna:          db   "U-G---C------------A"
dna_2_rna_len       equ  $ - dna_2_rna

; ---- Code
                    section .text
                    global to_rna

; ---- Entry point
to_rna:             ; Save RSI in temporary register, swap RSI and RDI
                    mov  r10, rsi
                    push rdi
                    pop  rsi
                    mov  rdi, r10

                    ; Re-use R10 for lookup table base address
                    lea  r10, [dna_2_rna]

convert_dna_2_rna:  ; Convert each character in the input sequence
                    xor rax, rax
                    xor rbx, rbx

                    ; Check for NUL character
                    mov byte al, [rsi]
                    cmp al, 0
                    je  convert_done

                    ; Compute lookup table index
                    sub al, 65
                    jge check_upper_index        ; index < 0 ?
                    jmp err_index                ;   so abort

check_upper_index:
                    cmp al, dna_2_rna_len        ; index > TBLSIZE ?
                    jge err_index                ;   so abort

                    ; Index valid, 0 <= index < TBLSIZE, do lookup
                    mov byte bl, [r10 + rax]
                    mov byte [rdi], bl
                    inc rsi
                    inc rdi
                    jmp convert_dna_2_rna

convert_done:       ; Normal return
err_index:          ; Error return

exit:               ; NUL-terminate output buffer
                    mov byte [rdi], 0
                    ret

