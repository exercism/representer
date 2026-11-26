section .text
global leap_year

_is_divisible:
    ; divides rdi by rcx
    ; sets zero flag based on reminder
    mov rax, rdi
    mov rdx, 0
    div rcx
    cmp rdx, 0
    ret

leap_year:
    ; not divisible by 4 -> not leap
    test rdi, 11b ; fast modulus by 4
    jnz _not_leap

    ; divisible by 4 and not divisible by 100 -> leap
    mov rcx, 100
    call _is_divisible
    jnz _leap

    ; divisible by 400 -> leap
    mov rcx, 400
    call _is_divisible
    jz _leap

_not_leap:
    mov rax, 0
    ret
_leap:
    mov rax, 1
    ret

