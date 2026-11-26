; vim:ft=nasm
bits 64
default rel
section .text
global age

;extern float age(enum planet planet, int seconds);
; rdi <- planet
; rsi <- secondes
; Note to myself: planet is an integer (0-9) not a string...
age:
    cvtsi2ss xmm0, rsi                 ; Convert seconds to single precision
    movss    xmm1, [earthyear]         ; Loads earthyear in sse register
    lea      rsi,  [orbits_ratios]     ; Pointer to orbits_ratios array
    mulss    xmm1, dword[rsi + rdi * 4]; xmm1 = earthyear * orbits_ratios[i]
    divss    xmm0, xmm1                ; xmm0 = seconds/(earthyear * orbits_ratios[i]
    ret

section .rodata
NULL            equ    0
earthyear:      dd 31557600.0
orbits_ratios:  dd 0.240846, 0.61519726, 1.0, 1.8808158, 11.862615, 29.447498, 84.016846, 164.79132,NULL
