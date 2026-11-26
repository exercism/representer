default rel

section .text

global mix_tracks
mix_tracks:
    ; Function signature:
    ;
    ;   void mix_tracks(int16_t result[8], const int16_t track_a[8], const int16_t track_b[8]);
    ;
    ; Parameters:
    ;
    ;   rdi: int16_t*, a pointer to the 16-byte alligned address of a
    ;     16-bit integer array of size 8, to which the results are
    ;     stored.
    ;
    ;   rsi: int16_t*, a pointer to the 16-byte alligned address of a
    ;   16-bit integer array of size 8.
    ;
    ;   rdx: int16_t*, a pointer to the 16-byte alligned address of
    ;   16-bit integer array of size 8.
    ;
    ; Return value:
    ;
    ;   None
    ;
    ; This function take the sums of the corresponding elements of the
    ; arrays pointed by rsi and rdx and stores the result in the array
    ; pointed by rdi. When the sum overflows, the sum must be set to
    ; INT32_MAX.
    movdqa xmm0, [rsi]
    paddsw xmm0, [rdx]
    movdqa [rdi], xmm0
    ret
    
global remove_bleed
remove_bleed:
    ; Function signature:
    ;
    ;   void remove_bleed(int16_t result[8], const int16_t track[8], const int16_t bleed[8]);
    ;
    ; Parameters:
    ;
    ;   rdi: int16_t*, a pointer to the (possibly unalligned) address
    ;     of a 16-bit integer array of size 8, to which the results
    ;     are stored.
    ;
    ;   rsi: int16_t*, a pointer to the 16-byte alligned address of a
    ;   16-bit integer array of size 8.
    ;
    ;   rdx: int16_t*, a pointer to the (possibly unaligned) address
    ;   of 16-bit integer array of size 8.
    ;
    ; Return value:
    ;
    ;   None
    ;
    ; This function subtracts the corresponding elements of the array
    ; pointed by rdx from those of the array pointed by rsi and stores
    ; the result in the array pointed by rdi. When the sum overflows,
    ; the sum must be set to INT32_MIN
    movdqa xmm0, [rsi]
    movdqu xmm1, [rdx]
    psubsw xmm0, xmm1
    movdqu [rdi], xmm0
    ret

global combine_meters
combine_meters:
    ; Function signature:
    ;
    ;   void combine_meters(uint8_t result[16], const uint8_t meter_a[16], const uint8_t meter_b[16]);
    ;
    ; Parameters:
    ;
    ;   rdi: int16_t*, a pointer to the 16-byte alligned address of a
    ;     16-bit integer array of size 8, to which the results are
    ;     stored.
    ;
    ;   rsi: int16_t*, a pointer to the 16-byte alligned address of an
    ;   unsigned 16-bit integer array of size 8.
    ;
    ;   rdx: int16_t*, a pointer to the 16-byte alligned address of an
    ;   unsigned 16-bit integer array of size 8.
    ;
    ; Return value:
    ;
    ;   None
    ;
    ; This function take the sum of the corresponding elements of the
    ; arrays pointed by rsi and rdx and stores the result in the array
    ; pointed by rdi. When the sum overflows, the sum must be set to
    ; UINT32_MAX
    movdqa xmm0, [rsi]
    paddusb xmm0, [rdx]
    movdqa [rdi], xmm0
    ret

global apply_fade
apply_fade:
    ; Function signature:
    ;
    ;   void apply_fade(int16_t result[], const int16_t track[], const int16_t gains[], size_t n);
    ;
    ; Parameters:
    ;
    ;   rdi: int16_t*, a pointer to the 16-byte alligned address of a
    ;     16-bit integer array, to which the results are stored.
    ;
    ;   rsi: int16_t*, a pointer to the 16-byte alligned address of an
    ;   unsigned 16-bit integer array.
    ;
    ;   rdx: int16_t*, a pointer to the 16-byte alligned address of an
    ;   unsigned 16-bit integer array.
    ;
    ;   rcx: size_t, the size of the arrays pointed by rdi, rsi and
    ;     rdx. This number is guaranteed to be positive and divisible
    ;     by eight.
    ;
    ; Return value:
    ;
    ;   None
    ;
    ; This function take the product of the corresponding elements of
    ; the arrays pointed by rsi and rdx, arithmetically shift right
    ; the products by 16 positions, and stores the result in the array
    ; pointed by rdi.

    ; Loop batches of eight backwardly.
.loop:
    sub rcx, 8
    movdqa xmm0, [rsi + 2 * rcx]
    pmulhw xmm0, [rdx + 2 * rcx]
    movdqa [rdi + 2 * rcx], xmm0
    jg .loop
    ret

section .bss
    saved_mxcsr resd 1
    temp_mxcsr resd 1
    
section .text
global attenuate_track
attenuate_track:
    ; Function signature:
    ;
    ;   void attenuate_track(int32_t result[], const int16_t samples[], const int32_t divisor[4], size_t n);
    ;
    ; Parameters:
    ;
    ;   rdi: int32_t*, a pointer to the 16-byte alligned address of a
    ;     32-bit integer array, to which the results are stored.
    ;
    ;   rsi: int16_t*, a pointer to the 16-byte alligned address of a
    ;     signed 16-bit integer array.
    ;
    ;   rdx: int32_t*, a pointer to the 16-byte alligned address of an
    ;     signed 32-bit integer array of size four. The four numbers
    ;     in this array are guaranteed to be identical.
    ;
    ;   rcx: size_t, the size of the arrays pointed by rdi and
    ;     rsi. This number is guaranteed to be positive and divisible
    ;     by four.
    ;
    ; Return value:
    ;
    ;   None
    ;
    ; This function compute the quotient in division of the
    ; corresponding elements of the array pointed by rsi and by those
    ; of the array pointed by rdx, and stores the result in the array
    ; pointed by rdi.
    movdqa xmm0, [rdx]          ; xmm0 = [4 copies of divisors (uint32_t)]
    cvtdq2ps xmm0, xmm0         ; xmm0 = [4 copies of divisors (floats)]

    ; We want to round fractional parts towards zero.
    stmxcsr [saved_mxcsr]       ; Save original MXCSR
    mov eax, [saved_mxcsr]
    or eax, 0x6000              ; Set both RC bits (bits 13 and 14)
    mov [temp_mxcsr], eax       ; Load the new MXCSR.
    ldmxcsr [temp_mxcsr]

    ; Loop batches of four backwardly.
.loop:
    sub rcx, 4
    pmovsxwd xmm1, [rsi + 2 * rcx] ; xmm1 = [four dividends (in32_t)]
    cvtdq2ps xmm2, xmm1         ; xmm2 = [4 dividends (floats)]
    divps xmm2, xmm0            ; xmm2 = [4 quotients (floats)]
    cvtps2dq xmm3, xmm2         ; xmm3 = [4 quotients (int32_t)]
    movdqa [rdi + 4 * rcx], xmm3 ;
    jg .loop
    
    ldmxcsr [saved_mxcsr]       ; Restore the original MXCSR
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
