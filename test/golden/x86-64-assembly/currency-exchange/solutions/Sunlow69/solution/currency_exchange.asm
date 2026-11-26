; Currency Exchange x86-64 implementation
; Assembler: NASM

default rel

section .rodata
    ; Contiguous string block (4 bytes per entry: 3 chars + null)
    ; This avoids a table of pointers and fixes PIE relocation errors.
    currency_strings:
        db "GBP", 0
        db "EUR", 0
        db "JPY", 0
        db "AUD", 0
        db "BRL", 0
        db "CNY", 0
        db "CAD", 0
        db "INR", 0

    ; Constants for floating point math
    f_100   dq 100.0
    f_1     dq 1.0

section .text

; Task 1: stringify_currency
; Signature: void stringify_currency(char *buffer, enum currency_t currency);
; rdi = buffer, rsi = currency (4-byte enum)
global stringify_currency
stringify_currency:
    ; Safety check: ensure currency is within 0-7
    cmp rsi, 7
    ja .done
    
    ; Calculate the address of the corresponding string
    ; Address = currency_strings + (index * 4)
    lea r8, [rel currency_strings]
    shl rsi, 2                  ; Multiply index by 4 (since each entry is 4 bytes)
    add r8, rsi
    
    ; Copy 4 bytes (3 chars + null terminator)
    mov eax, [r8]
    mov [rdi], eax

.done:
    ret

; Task 2: exchange_rate
; Signature: double exchange_rate(enum currency_t domestic, enum currency_t foreign, const double *values);
; edi = domestic, esi = foreign, rdx = values pointer
; Result: xmm0 = values[foreign] / values[domestic]
global exchange_rate
exchange_rate:
    ; Use move instructions for 64-bit floating point
    movsd xmm0, [rdx + rsi * 8] ; xmm0 = values[foreign]
    movsd xmm1, [rdx + rdi * 8] ; xmm1 = values[domestic]
    divsd xmm0, xmm1            ; xmm0 = xmm0 / xmm1
    ret

; Task 3: get_value_of_bills
; Signature: uint64_t get_value_of_bills(unsigned long long denomination, unsigned short number_of_bills);
; rdi = denomination, rsi = number_of_bills
global get_value_of_bills
get_value_of_bills:
    movzx rsi, si               ; Ensure si is treated as 16-bit unsigned
    mov rax, rdi
    mul rsi                     ; rax = rax * rsi (unsigned)
    ret

; Task 4: get_number_of_bills
; Signature: unsigned int get_number_of_bills(float amount, unsigned long long denomination);
; xmm0 = amount (float), rdi = denomination
global get_number_of_bills
get_number_of_bills:
    cvtsi2ss xmm1, rdi          ; Convert denomination to float
    divss xmm0, xmm1            ; amount / denomination
    roundss xmm0, xmm0, 1       ; Round down (floor)
    cvtss2si eax, xmm0          ; Convert result to int
    ret

; Task 5: exchangeable_value
; Signature: uint32_t exchangeable_value(float budget, double exchange_rate, uint8_t spread, unsigned long long denomination);
; xmm0 = budget (float), xmm1 = exchange_rate (double), rdi (dil) = spread, rsi = denomination
global exchangeable_value
exchangeable_value:
    ; 1. Convert spread to double and calculate (1 + spread/100)
    ; In System V ABI, the 1st integer arg is rdi, the 2nd is rsi
    movzx rdi, dil              ; rdi = spread (0-255)
    cvtsi2sd xmm2, rdi          ; xmm2 = spread (double)
    divsd xmm2, [rel f_100]     ; xmm2 = spread / 100.0
    addsd xmm2, [rel f_1]       ; xmm2 = 1.0 + spread / 100.0
    
    ; 2. actual_rate = exchange_rate * (1 + spread/100)
    mulsd xmm1, xmm2            ; xmm1 = actual_rate (double)
    
    ; 3. Convert budget to double and calculate new_currency_amount
    cvtss2sd xmm0, xmm0         ; Convert budget (float in xmm0) to double
    divsd xmm0, xmm1            ; xmm0 = budget / actual_rate
    
    ; 4. Calculate number of bills: floor(amount / denomination)
    ; denomination is the 2nd integer argument, passed in rsi
    cvtsi2sd xmm1, rsi          ; xmm1 = denomination (double)
    divsd xmm0, xmm1            ; xmm0 = amount / denomination
    roundsd xmm0, xmm0, 1       ; xmm0 = floor(result)
    
    ; 5. Final value = number_of_bills * denomination
    mulsd xmm0, xmm1            ; xmm0 = floor_bills * denomination
    cvttsd2si rax, xmm0         ; Convert to integer (truncate)
    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif