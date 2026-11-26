default rel

section .rodata
orbital_periods:
    MERCURY: dd 0.2408467
    VENUS:   dd 0.61519726
    EARTH:   dd 1.0
    MARS:    dd 1.8808158
    JUPITER: dd 11.862615
    SATURN:  dd 29.447498
    URANUS:  dd 84.016846
    NEPTUNE: dd 164.79132

earth_seconds: dd 31557600.0

section .text
global age
;;; rdi <- planet
;;; rsi <- seconds
age:
    ;;; xmm0 <- (float)seconds
    cvtsi2ss xmm0, rsi

    ;;; xmm1 <- earth_seconds
    movss xmm1, [earth_seconds]

    ;;; xmm1 <- planet_seconds <- earth_seconds * orbital_periods[planet]
    lea rbx, [orbital_periods]
    mulss xmm1, [rbx + rdi * 4]

    ;;; xmm0 <- age <- seconds / planet_seconds
    divss xmm0, xmm1

    ret
;;; xmm0 <- age

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
