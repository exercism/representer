; Everything that comes after a semicolon (;) is a comment.

; Some of the functions below make use of an enum currency_t defined as:
; enum currency_t {
;    GBP,
;    EUR,
;    JPY,
;    AUD,
;    BRL,
;    CNY,
;    CAD,
;    INR
; };

section .rodata
currencies:
    db "GBP", 0
    db "EUR", 0
    db "JPY", 0
    db "AUD", 0
    db "BRL", 0
    db "CNY", 0
    db "CAD", 0
    db "INR", 0

percent:
    dq 0.01

section .text

; You should implement functions in the .text section.
; A skeleton is provided for the first function.

; The global directive makes a function visible to the test files.
global stringify_currency
stringify_currency:
    lea rax, [rel currencies]
    mov eax, [rax + rsi*4]
    mov [rdi], eax
    ret

global exchange_rate
exchange_rate:
    vmovsd xmm0, [rdx + rsi*8]
    vdivsd xmm0, [rdx + rdi*8]
    ret

global get_value_of_bills
get_value_of_bills:
    mov eax, edi
    imul rax, rsi
    ret

global get_number_of_bills
get_number_of_bills:
    vcvtss2si rax, xmm0, {rd-sae}
    xor edx, edx
    div rdi
    ret

global exchangeable_value
exchangeable_value:
    add edi, 100
    vcvtsi2sd xmm2, edi
    vmulsd xmm2, [rel percent]
    vmulsd xmm1, xmm2
    vcvtss2sd xmm0, xmm0
    vdivsd xmm0, xmm1
    vcvtsd2si rax, xmm0, {rd-sae}
    xor edx, edx
    div rsi
    imul rax, rsi
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif