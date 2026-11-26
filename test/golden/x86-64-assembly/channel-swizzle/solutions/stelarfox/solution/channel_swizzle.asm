section .rodata
align 16
RGBA2BGRA db 2,1,0,3,6,5,4,7,10,9,8,11,14,13,12,15
section .text

global to_display_order
to_display_order:
    ; TODO: implement the `to_display_order` function
    ;
    ; This function converts a whole image from RGBA to BGRA, one block at a time.
    ; In every pixel the red and blue channels are swapped, and green and alpha are left in place.
    ;
    ; This function takes as arguments, in order:
    ; 1. `result`: 16-byte aligned memory address where the converted blocks are written, 16 bytes per block
    ; 2. `pixels`: 16-byte aligned memory address of the source blocks, 4 pixels per block, each pixel 4 bytes in RGBA order
    ; 3. `block_count`: the number of blocks, always greater than `0`, as a 64-bit unsigned integer
    ;
    ; Each channel is 1-byte wide and a pixel has 4 channels.
    ; A block has 4 pixels.
    ;
    ; The channel-reordering control mask may be defined as a packed constant.
    ;
    ; This function has no return value.
    ; The computation should use SIMD instructions, not scalar operations.
    movdqa xmm1, [rel RGBA2BGRA]    ; xmm1 has the RGBA (0xAABBGGRR) to BGRA (0xAARRGGBB) constant
.loop:                         ; loop here
    movdqa xmm0, [rsi]         ; move the input xmm0 from rsi+loopx16
    lea rsi,[rsi+16]           ; gets the next rsi+=16
    pshufb xmm0, xmm1          ; does the rotation based on the constant (exchanging BB and RR leaving the rest)
    movdqa [rdi], xmm0         ; stores at destination + loop x 16
    lea rdi,[rdi+16]           ; rdi+=16 (to increment destination position)
    dec rdx                    ; decrements rdx
    jnz .loop                  ; jump if not zero to loop
    ret                        ; finish and return

global fill_region
fill_region:
    ; TODO: implement the `fill_region` function
    ;
    ; This function fills a region of `block_count` blocks with copies of one color.
    ;
    ; This function takes as arguments, in order:
    ; 1. `result`: 16-byte aligned memory address where the filled blocks are written, 16 bytes per block
    ; 2. `color`: 16-byte aligned memory address of one pixel, 4 bytes in RGBA order
    ; 3. `block_count`: the number of blocks to fill, always greater than `0`, as a 64-bit unsigned integer
    ;
    ; Each channel is 1-byte wide and a pixel has 4 channels.
    ; A block has 4 pixels.
    ;
    ; This function has no return value.
    ; The computation should use SIMD instructions, not scalar operations.
    movdqa xmm1, [rsi]             ; moves the color in the first 32 bits of the 16 byte alignment to xmm1
    pshufd xmm0, xmm1, 0           ; shuffle them to all xmm0 (so moves the 00 lower everywhere)
.loop:
    movdqa [rdi], xmm0             ; stores the result filling all to [rdi + loopx16]
    lea rdi,[rdi+16]               ; rdi+=16
    dec rdx                        ; decrements rdx 
    jnz .loop                      ; jump meanwhile rdx not 0
    ret                            ; finishes and return

global weave_scanlines
weave_scanlines:
    ; TODO: implement the `weave_scanlines` function
    ;
    ; This function interleaves two rows of 16 samples each into a single row of 32 samples.
    ;
    ; This function takes as arguments, in order:
    ; 1. `result`: 16-byte aligned memory address where the 32 interleaved samples are written
    ; 2. `first`: 16-byte aligned memory address of the first row, with 16 samples, each an 8-bit value
    ; 3. `second`: 16-byte aligned memory address of the second row, with 16 samples, each an 8-bit value
    ;
    ; Even-indexed samples are taken from `first`, while odd-indexed samples are taken from `second`.
    ;
    ; This function has no return value.
    ; The computation should use SIMD instructions, not scalar operations.
    movdqa xmm1, [rsi]    ; xmm1 is first 16 samples (from rsi)
    movdqa xmm2, [rdx]    ; xmm2 is second 16 samples (from rdx)
    movdqa xmm0, xmm1     ; move xmm0=xmm1
    punpcklbw xmm0, xmm2  ; interlocks the lower part of xmm0 (=xmm1) vs xmm2 placing first xmm0 then the other
    punpckhbw xmm1, xmm2  ; interlocks the highter part byte by byte (first xmm1)
    movdqa [rdi],xmm0     ; stores first chunk of 16 into rdi address
    movdqa [rdi+16],xmm1  ; stores second chunk of 16 into rdi+16 address
    ret                   ; finishes and returns

global pack_samples
pack_samples:
    ; TODO: implement the `pack_samples` function
    ;
    ; This function narrows two groups of 8 working values into one row of 16 samples, in order.
    ; The values should be clamped to the range `0` to `255`.
    ;
    ; This function takes as arguments, in order:
    ; 1. `result`: 16-byte aligned memory address where the 16 clamped samples are written, each an 8-bit value
    ; 2. `first`: 16-byte aligned memory address of the first 8 working values, each a 16-bit signed integer
    ; 3. `second`: 16-byte aligned memory address of the next 8 working values, each a 16-bit signed integer
    ;
    ; This function has no return value.
    ; The computation should use SIMD instructions, not scalar operations.
    movdqa xmm0, [rsi]        ; moves xmm0 the first 16 bit 8 values
    movdqa xmm1, [rdx]        ; moves xmm1 the second 16 bit 8 values 
    packuswb xmm0, xmm1       ; converts 16 values to 8 bits if negative becomes 0 if >255 = 255 making the entire 
                       ;xmm0  into the first 64 bits and the entire xmm1 into the upper 64 bits making word to byte
    movdqa [rdi], xmm0        ; stores the 16 values of 8 bits in destination [rdi] address
    ret                       ; finishes and return

global split_coordinates
split_coordinates:
    ; TODO: implement the `split_coordinates` function
    ;
    ; This function separates four interleaved (x, y) points into two vectors.
    ; The first vector holds only `x` coordinates, and the second holds only `y` coordinates.
    ;
    ; This function takes as arguments, in order:
    ; 1. `xs`: 16-byte aligned memory address where the 4 x coordinates are written, 4 32-bit floating-point numbers
    ; 2. `ys`: 16-byte aligned memory address where the 4 y coordinates are written, 4 32-bit floating-point numbers
    ; 3. `first`: 16-byte aligned memory address of the first two points, 4 32-bit floating-point numbers as `{x0, y0, x1, y1}`
    ; 4. `second`: 16-byte aligned memory address of the next two points, 4 32-bit floating-point numbers as `{x2, y2, x3, y3}`
    ;
    ; The coordinates should be stored in the same order they are given:
    ; xs = {x0, x1, x2, x3}
    ; ys = {y0, y1, y2, y3}
    ;
    ; This function has no return value.
    ; The computation should use SIMD instructions, not scalar operations.
    movdqa xmm0, [rdx]        ; xmm0 = data x0,y0,x1,y1 
    movdqa xmm2, [rcx]        ; xmm2 = data x2,y2,x3,y3
    movdqa xmm1,xmm0          ; xmm0 = xmm1 = x0,y0,x1,y1 
    shufps xmm0, xmm2, 0x88   ; xmm0 becomes from in order x0,x1,x2,x3 because 88 -> from 8 = first and third
    shufps xmm1, xmm2, 0xDD   ; xmm1 becomes second,4th (from xmm1) then the same from xmm2
    movdqa [rdi], xmm0        ; stores x0,x1,x2,x3 at rdi address (xs)
    movdqa [rsi], xmm1        ; stores y0,y1,y2,y3 at rsi address (ys) 
    ret                       ; finsihes and returns

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
