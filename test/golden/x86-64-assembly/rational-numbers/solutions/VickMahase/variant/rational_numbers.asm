default rel

section .text

global add_rationals
global sub_rationals
global mul_rationals
global div_rationals
global abs_rational
global exprational
global expreal
global reduce

; -----------------------------------------------------------------------------
; Helper: gcd(rdi: a, rsi: b) -> rax
; Returns the GCD of the absolute values of a and b.
; -----------------------------------------------------------------------------
gcd:
    push rbx
    mov rax, rdi
    mov rbx, rsi
    ; Take absolute values
    test rax, rax
    jns .abs_b
    neg rax
.abs_b:
    test rbx, rbx
    jns .loop
    neg rbx
.loop:
    test rbx, rbx
    jz .done
    xor rdx, rdx
    div rbx
    mov rax, rbx
    mov rbx, rdx
    jmp .loop
.done:
    pop rbx
    ret

; -----------------------------------------------------------------------------
; rational_t reduce(rational_t r)
; rdi: num, rsi: den
; Returns: rax: reduced_num, rdx: reduced_den
; -----------------------------------------------------------------------------
reduce:
    push rbx
    push rbp
    mov rbx, rdi            ; rbx = num
    mov rbp, rsi            ; rbp = den

    ; Handle 0 numerator
    test rbx, rbx
    jnz .calc_gcd
    mov rax, 0
    mov rdx, 1
    jmp .exit

.calc_gcd:
    mov rdi, rbx
    mov rsi, rbp
    call gcd                ; rax = gcd(|num|, |den|)
    
    mov rdi, rax            ; rdi = gcd
    
    ; num = num / gcd
    mov rax, rbx
    cqo
    idiv rdi
    mov rbx, rax
    
    ; den = den / gcd
    mov rax, rbp
    cqo
    idiv rdi
    mov rbp, rax

    ; Standard form: denominator must be positive
    test rbp, rbp
    jns .success
    neg rbx
    neg rbp

.success:
    mov rax, rbx
    mov rdx, rbp
.exit:
    pop rbp
    pop rbx
    ret

; -----------------------------------------------------------------------------
; rational_t add_rationals(r1, r2)
; (a1*b2 + a2*b1) / (b1*b2)
; rdi: a1, rsi: b1, rdx: a2, rcx: b2
; -----------------------------------------------------------------------------
add_rationals:
    push rbx
    push rbp
    push r12
    
    ; a1*b2
    mov rax, rdi
    imul rax, rcx
    mov rbx, rax            ; rbx = a1*b2
    
    ; a2*b1
    mov rax, rdx
    imul rax, rsi
    add rbx, rax            ; rbx = num = a1*b2 + a2*b1
    
    ; b1*b2
    mov rax, rsi
    imul rax, rcx           ; rax = den = b1*b2
    
    mov rdi, rbx
    mov rsi, rax
    call reduce
    
    pop r12
    pop rbp
    pop rbx
    ret

; -----------------------------------------------------------------------------
; rational_t sub_rationals(r1, r2)
; (a1*b2 - a2*b1) / (b1*b2)
; -----------------------------------------------------------------------------
sub_rationals:
    push rbx
    push rbp
    
    mov rax, rdi
    imul rax, rcx
    mov rbx, rax            ; a1*b2
    
    mov rax, rdx
    imul rax, rsi
    sub rbx, rax            ; a1*b2 - a2*b1
    
    mov rax, rsi
    imul rax, rcx           ; b1*b2
    
    mov rdi, rbx
    mov rsi, rax
    call reduce
    
    pop rbp
    pop rbx
    ret

; -----------------------------------------------------------------------------
; rational_t mul_rationals(r1, r2)
; (a1*a2) / (b1*b2)
; -----------------------------------------------------------------------------
mul_rationals:
    mov rax, rdi
    imul rax, rdx
    mov rdi, rax            ; a1*a2
    
    mov rax, rsi
    imul rax, rcx
    mov rsi, rax            ; b1*b2
    
    call reduce
    ret

; -----------------------------------------------------------------------------
; rational_t div_rationals(r1, r2)
; (a1*b2) / (a2*b1)
; -----------------------------------------------------------------------------
div_rationals:
    mov rax, rdi
    imul rax, rcx
    mov rdi, rax            ; a1*b2
    
    mov rax, rdx
    imul rax, rsi
    mov rsi, rax            ; a2*b1
    
    call reduce
    ret

; -----------------------------------------------------------------------------
; rational_t abs_rational(r)
; -----------------------------------------------------------------------------
abs_rational:
    test rdi, rdi
    jns .den_check
    neg rdi
.den_check:
    test rsi, rsi
    jns .do_reduce
    neg rsi
.do_reduce:
    call reduce
    ret

; -----------------------------------------------------------------------------
; rational_t exprational(rational_t r, int64 n)
; rdi: num, rsi: den, rdx: n
; -----------------------------------------------------------------------------
exprational:
    push rbx
    push r12
    push r13
    push r14
    
    mov rbx, rdi            ; base_num
    mov r12, rsi            ; base_den
    mov r13, rdx            ; n
    
    ; Handle n = 0
    test r13, r13
    jnz .check_negative
    mov rax, 1
    mov rdx, 1
    jmp .exit

.check_negative:
    mov r14, r13
    test r14, r14
    jns .power_loop
    neg r14                 ; m = |n|
    ; Swap base num/den for negative exponent
    mov rdi, rbx
    mov rbx, r12
    mov r12, rdi

.power_loop:
    ; Use standard integer power logic
    mov rax, 1              ; result_num
    mov rdx, 1              ; result_den
    
.loop:
    test r14, r14
    jz .done
    imul rax, rbx
    imul rdx, r12
    dec r14
    jmp .loop

.done:
    mov rdi, rax
    mov rsi, rdx
    call reduce

.exit:
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

; -----------------------------------------------------------------------------
; float expreal(int64 x, rational_t r)
; x^(a/b) = root(x^a, b)
; rdi: x, rsi: num, rdx: den
; return: xmm0 (float)
; -----------------------------------------------------------------------------
extern pow
expreal:
    sub rsp, 8
    
    ; Convert x to double (xmm0)
    cvtsi2sd xmm0, rdi
    
    ; Calculate exponent = (double)num / (double)den (xmm1)
    cvtsi2sd xmm1, rsi
    cvtsi2sd xmm2, rdx
    divsd xmm1, xmm2
    
    ; pow(double base, double exp)
    call pow wrt ..plt
    
    ; Convert result to float
    cvtsd2ss xmm0, xmm0
    
    add rsp, 8
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif