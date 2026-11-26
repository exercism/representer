default rel

section .text
global age
age:
    ; xmm0 := Age in Seconds
    pxor xmm0, xmm0
    cvtsi2ss xmm0, esi

    ; xmm0 /= Seconds per Year
    divss xmm0, [seconds_per_year]

    ; xmm0 /= Orbital Period of Planet
    lea rax, [orbital_periods]
    divss xmm0, dword [rax + rdi * 4]
    ret

section .rodata
seconds_per_year:
    dd 31557600.0
orbital_periods:
    dd 0.24084670
    dd 0.61519726
    dd 1.00000000
    dd 1.88081580
    dd 11.8626150
    dd 29.4474980
    dd 84.0168460
    dd 164.791320