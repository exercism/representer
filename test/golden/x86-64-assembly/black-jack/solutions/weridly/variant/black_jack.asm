; Everything that comes after a semicolon (;) is a comment

C2 equ 2
C3 equ 3
C4 equ 4
C5 equ 5
C6 equ 6
C7 equ 7
C8 equ 8
C9 equ 9
C10 equ 10
CJ equ 11
CQ equ 12
CK equ 13
CA equ 14

TRUE equ 1
FALSE equ 0

section .text

; You should implement functions in the .text section

; the global directive makes a function visible to the test files
global value_of_card
value_of_card:
    ; This function takes as parameter a number representing a card
    ; The function should return the numerical value of the passed-in card

    mov rax, rdi

    cmp rdi, 14
    je .ace

    cmp rdi, 10
    jge .face
    
    ret

.face:
    mov rax, 10
    ret

.ace:
    mov rax, 1
    ret
    

global higher_card
higher_card:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return which card has the higher value
    ; If both have the same value, both should be returned
    ; If one is higher, the second one should be 0

    push rdi
    push rsi

    call value_of_card
    
    mov rbx, rax

    pop rsi
    pop rdi
    
    push rbx
    push rsi
    push rdi

    mov rdi, rsi
    
    call value_of_card
    mov rcx, rax

    pop r9
    pop r10
    pop r8

    cmp r8, rcx
    je .equal
    jg .more
    jl .less

    ret

.more:
    mov rax, r9
    mov rdx, 0
    ret

.less:
    mov rax, r10
    mov rdx, 0
    
    ret

.equal:
    mov rax, r9
    mov rdx, r10
        
    ret

global value_of_ace
value_of_ace:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return the value of an upcoming ace

    mov rbx, rdi

    cmp rdi, 14
    je .has_ace

    cmp rsi, 14
    je .has_ace

    call value_of_card
    push rax
    
    mov rdi, rsi
    call value_of_card
    
    push rax

    pop rbx
    pop rcx

    mov r12, rbx
    add r12, rcx
    
    cmp r12, 10
    jle .lower_limit

    cmp r12, 10
    jg .has_ace
    
    ret
.has_ace:
    mov rax, 1
    ret
.lower_limit:
    mov rax, 11
    ret

global is_blackjack
is_blackjack:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a blackjack, and FALSE otherwise

    mov rax, FALSE
    
    cmp rdi, 14
    je .check1 ; if first card is ace

    cmp rsi, 14
    je .check2 ; if second card is ace
    
    ret
.check1:
    mov r12, rdi
    mov rdi, rsi

    call value_of_card
    
    cmp rax, 10
    
    je .set_rax
    jne .unset_rax

    mov rdi, r12
    
    ret

.check2:
    call value_of_card
    cmp rax, 10

    je .set_rax
    jne .unset_rax
    
    ret

.set_rax:
    mov rax, TRUE
    ret
.unset_rax:
    mov rax, FALSE
    ret

global can_split_pairs
can_split_pairs:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards can be split into two pairs, and FALSE otherwise

    call value_of_card
    push rax

    push rdi
    mov rdi, rsi
    
    call value_of_card
    push rax
    
    pop rdi
    pop rax
    pop rsi

    cmp rdi, rsi
    mov rax, FALSE
    
    je .set_true
    ret
.set_true:
    mov rax, TRUE

    ret

global can_double_down
can_double_down:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a hand that can be doubled down, and FALSE otherwise

    call value_of_card
    push rax

    mov rdi, rsi
    call value_of_card

    pop rdi
    add rdi, rax

    mov rax, FALSE
    
    cmp rdi, 9
    je .set_flag
    cmp rdi, 10
    je .set_flag
    cmp rdi, 11
    je .set_flag
    ret
.set_flag:
    mov rax, TRUE
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
