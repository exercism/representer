section .text
global is_valid

; Function to validate an ISBN-10 number
; Input: rdi = pointer to ISBN string
; Output: eax = 1 if valid, 0 if invalid
is_valid:
    ; Save callee-saved registers
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    ; Initialize registers
    xor r12, r12        ; r12 = digit counter (must be exactly 10)
    mov r13, 10         ; r13 = multiplier (starts at 10)
    xor r14, r14        ; r14 = sum
    mov r15, rdi        ; r15 = current position in string
    
    ; Check for empty string
    cmp byte [r15], 0
    je .invalid
    
.process_loop:
    ; Get the current character
    movzx ebx, byte [r15]
    
    ; Check for end of string
    test ebx, ebx
    jz .check_sum
    
    ; Skip dashes
    cmp ebx, '-'
    je .next_char
    
    ; Check if we already have 10 digits
    cmp r12, 10
    jge .invalid
    
    ; Check if character is a digit
    cmp ebx, '0'
    jl .check_for_X
    cmp ebx, '9'
    jg .check_for_X
    
    ; It's a digit, convert to numeric value
    sub ebx, '0'
    jmp .process_digit
    
.check_for_X:
    ; Only 'X' is allowed as the 10th character (representing value 10)
    cmp ebx, 'X'
    jne .invalid
    
    ; Check if this is the last digit position
    cmp r12, 9
    jne .invalid
    
    ; X represents value 10
    mov ebx, 10
    
.process_digit:
    ; Multiply digit by position weight and add to sum
    mov eax, ebx
    imul eax, r13d      ; Fixed: Use 32-bit register r13d instead of 64-bit r13
    add r14d, eax
    
    ; Move to next position
    inc r12
    dec r13
    
.next_char:
    ; Move to next character
    inc r15
    jmp .process_loop
    
.check_sum:
    ; We need exactly 10 digits
    cmp r12, 10
    jne .invalid
    
    ; Check if sum is divisible by 11
    mov eax, r14d
    xor edx, edx
    mov ecx, 11
    div ecx
    
    ; If remainder is 0, ISBN is valid
    test edx, edx
    jnz .invalid
    
    ; Valid ISBN
    mov eax, 1
    jmp .done
    
.invalid:
    ; Invalid ISBN
    xor eax, eax
    
.done:
    ; Restore callee-saved registers
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif