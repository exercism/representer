section .text
global square
square:
    cmp dil, 0                ; Check for argument smaller than 1
    jle invalid_square
    cmp dil, 64               ; Check for argument greater than 64
    jg invalid_square
    mov rax, 1                ; Load 2^0 into rax, the return register
    mov cl, dil               ; Move the square number into cl, since shl only works with cl as shift count operand
    dec cl                    ; decrement square number.
                              ; This is since square 1 has 1, or 2^0 grains, square 2 has 2, or 2^1 grains, etc.
    shl rax, cl               ; Shift rax left by cl places.
                              ; This is equivalent to calculating 2^cl, but doesn't need to loop cl times and perform imul
    jmp end                   ; jump past the instruction setting rax to 0 when invalid square number was passed
invalid_square:
    mov rax, 0                ; set rax to 0 if invalid square number was passed
end:
    ret

global total
total:
    ; Each square has a power of 2 grains on it. This means the binary representation has one bit set.
    ; This also means that no other square's grain count has that bit set.
    ; Since there are 64 squares, there is 64 1s
    ; If they are added, the result will be a string of 64 1s, or 0xFFFFFFFFFFFFFFFF
    mov rax, 0xFFFFFFFFFFFFFFFF
    ret
