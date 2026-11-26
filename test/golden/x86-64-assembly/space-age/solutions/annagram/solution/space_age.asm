default rel

section .rodata
base: dd 31557600            ; Seconds in an earth year
planets:
    mercury: dd 0.2408467
    venus:   dd 0.61519726
    earth:   dd 1.0
    mars:    dd 1.8808158
    jupiter: dd 11.862615
    saturn:  dd 29.447498
    uranus:  dd 84.016846
    neptune: dd 164.79132

section .text
global age
age:
    cvtsi2ss xmm1, [base]         ; Convert the base from integer to float
    lea rdx, [planets]            ; Because we are compiling in pie, get relative address
    mulss xmm1, [rdx + rdi * 4]   ; Multiply the base by the correct planet multiplier
    cvtsi2ss xmm0, esi            ; Convert the argument passed from int to float
    divss xmm0, xmm1              ; Divide the seconds in a year on the planet by the seconds received
    ret
