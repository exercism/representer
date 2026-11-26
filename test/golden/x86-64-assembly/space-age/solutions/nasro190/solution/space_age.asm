default rel

; define age function
global age
age:
    ; load address of orbital_periods array
    lea rbx, [orbital_periods]
    ; convert age in seconds to a float
    cvtsi2ss xmm0, rsi
    ; load number of seconds in a year as a float
    mov rax, 31557600
    cvtsi2ss xmm1, rax
    ; divide age by number of seconds in a year
    divss xmm0, xmm1
    ; divide by orbital period of specified planet
    divss xmm0, [rbx+rdi*4]
    ; return age as a float
    ret

section .data
    ; orbital periods of planets in Earth years
    orbital_periods dd 0.2408467, 0.61519726, 1.0, 1.8808158, 11.862615, 29.447498, 84.016846, 164.79132
    
%ifidn __OUTPUT_FORMAT__,elf64
    ; specify no stack or heap memory allocation, execution, or writing in notes section
    section .note.GNU-stack noalloc noexec nowrite progbits
%endif
