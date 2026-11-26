%include "debug.mac"
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

section .data
cu: db "GBP", 0
 db "EUR", 0
 db "JPY", 0
 db "AUD", 0
 db "BRL", 0
 db "CNY", 0
 db "CAD", 0
 db "INR", 0


section .text


; You should implement functions in the .text section.
; A skeleton is provided for the first function.

; The global directive makes a function visible to the test files.
global stringify_currency
stringify_currency:
    ; This function has signature: void stringify_currency(char *buffer, enum currency_t currency);
    ; It stores the string representation for the value of a enum currency_t in the passed buffer
    ;debugu64 rdi, rsi, rdx, rcx, r8, r9
    imul rsi, 4
    lea rax, [rel cu]
    add rsi, rax
    mov rcx, 4
    rep movsb
    ret

; TODO: define the 'exchange_rate' function.
; This function has signature: double exchange_rate(enum currency_t domestic_currency, enum currency_t foreign_currency, const double *value_in_US_dollars);
; It returns the value of one unit of foreign currency in the domestic currency.
; `value_in_US_dollars` is a pointer to the beginning of an array of `double` with the value of 1 unit of each enum currency_t, in dollars.
global exchange_rate
exchange_rate:
    imul rdi, 8
    add rdi, rdx
    movsd xmm1, [rdi]
    imul rsi, 8
    add rsi, rdx
    movsd xmm0, [rsi]
    divsd xmm0, xmm1
    ret

; TODO: define the 'get_value_of_bills' function.
; This function has signature: uint64_t get_value_of_bills(unsigned long long denomination, unsigned short number_of_bills);
; It returns the total value of the bills.
global get_value_of_bills
get_value_of_bills:
    ;debugu64 rdi, rsi, rdx, rcx, r8, r9
    movsx rax, si
    imul rax, rdi
    ret

; TODO: define the 'get_number_of_bills' function.
; This function has signature: unsigned int get_number_of_bills(float amount, unsigned long long denomination);
; It returns the nuumber of whole bills that can be received within the given amount.
global get_number_of_bills
get_number_of_bills:
    ;debugu64 rdi, rsi, rdx, rcx, r8, r9
    cvtsi2ss xmm1, rdi

    divss    xmm0, xmm1
    roundss xmm0, xmm0, 1
    cvtss2si eax, xmm0
    ret

; TODO: define the 'exchangeable_value' function.
; This function has signature: uint32_t exchangeable_value(float budget, double exchange_rate, uint8_t spread, unsigned long long denomination);
; It returns the maximum value of the new currency after calculating the exchange rate adjusted by the spread.
global exchangeable_value
exchangeable_value:
    ;debugu64 rdi, rsi, rdx, rcx, r8, r9
    ; debugf32_xmm xmm0   
    cvtsd2ss xmm1, xmm1 ;exchange_rate
    divss xmm0, xmm1    ;budget / exchange_rate
    ; debugf32_xmm xmm0   
    movsx rdi, dil      ;spread
    add rdi, 100        ;spread + 100
    cvtsi2ss xmm2, rdi
    divss xmm0, xmm2      ;budget / exchange_rate / (spread + 100)
    ; debugf32_xmm xmm0
    mov rax, 100        ;100
    cvtsi2ss xmm3, rax  ;100
    mulss xmm0, xmm3    ;budget / exchange_rate / (spread + 100) * 100
    ; debugf32_xmm xmm0
    mov rdi, rsi        ;denomination
    ; debugu64 rdi
    sub rsp, 8
    call get_number_of_bills    ;takes xmm0 and rdi
    add rsp, 8
    imul rax, rdi
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
