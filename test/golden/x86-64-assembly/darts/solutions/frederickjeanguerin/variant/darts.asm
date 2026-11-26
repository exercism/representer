default rel

OUTSIDE_ANY_POINTS equ 0
OUTER_CIRCLE_POINTS equ 1
MIDDLE_CIRCLE_POINTS equ 5
INNER_CIRCLE_POINTS equ 10

section .rodata
    OUTER_CIRCLE_RADIUS_SQUARED dq 100.0    ; 10.0 * 10.0
    MIDDLE_CIRCLE_RADIUS_SQUARED dq 25.0    ; 5.0 * 5.0
    INNER_CIRCLE_RADIUS_SQUARED dq 1.0      ; 1.0 * 1.0

section .text

global score
score:
    ; The function has C type signature uint8_t score(double x, double y)
        
        ; First compute x * x + y * y
        mulsd xmm0, xmm0
        mulsd xmm1, xmm1
        addsd xmm0, xmm1

        comisd xmm0, qword [INNER_CIRCLE_RADIUS_SQUARED]
        jbe .inside_inner_circle

        comisd xmm0, qword [MIDDLE_CIRCLE_RADIUS_SQUARED]
        jbe .inside_middle_circle

        comisd xmm0, qword [OUTER_CIRCLE_RADIUS_SQUARED]
        jbe .inside_outer_circle

    .outside_any_circle:
        mov AL, OUTSIDE_ANY_POINTS
        ret

    .inside_inner_circle:
        mov AL, INNER_CIRCLE_POINTS
        ret

    .inside_middle_circle:
        mov AL, MIDDLE_CIRCLE_POINTS
        ret

    .inside_outer_circle:
        mov AL, OUTER_CIRCLE_POINTS
        ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
