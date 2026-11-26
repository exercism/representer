/* For macOS*/
/*.section __TEXT,__text,regular,pure_instructions
.p2align 2
.global _leap_year

_leap_year:*/
/* For Linux*/ 
.text
.globl leap_year

leap_year:
        mov x8, #400
        mov x7, #100
        mov x6, #4
        sdiv x1, x0, x8
        msub x2, x1, x8, x0
        cmp x2, #0
        b.eq _return_leap_year
        
        sdiv x1, x0, x7
        msub x2, x1, x7, x0
        cmp x2, #0
        b.eq _return_not_leap_year


        sdiv x1, x0, x6
        msub x2, x1, x6, x0
        cmp x2, #0
        b.eq _return_leap_year
        
        b _return_not_leap_year

_return_leap_year:
        mov x0, #1
        ret

_return_not_leap_year: 
        mov x0, #0
        ret
