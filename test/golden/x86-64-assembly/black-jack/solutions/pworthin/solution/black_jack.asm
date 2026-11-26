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
    cmp rdi, 10
    jle numeric_card
    cmp rdi, 14
    je ace
    mov rax, 10
    jmp end
    ace:
        mov rax, 1
        jmp end
    numeric_card:
        mov rax, rdi
    end:
    ret

global higher_card
higher_card:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return which card has the higher value
    ; If both have the same value, both should be returned
    ; If one is higher, the second one should be 0
    call value_of_card
    mov rbx, rax ; Store first card value in rbx
    mov r8, rdi ; Store first card in R8
    mov rdi, rsi
    call value_of_card
    cmp rax, rbx ; Compare second card value, first card value
    jg second_card
    je equals
    first_card:
        mov rax, r8
        mov rdx, 0
        ret
    second_card:
        mov rax, rsi
        mov rdx, 0
        ret
    equals:
        mov rax, r8
        mov rdx, rsi
        ret
    ret

global value_of_ace
value_of_ace:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return the value of an upcoming ace
    cmp rdi, 14; check if already ace
    je ace_is_one
    call value_of_card
    mov r8, rax
    mov rdi, rsi
    cmp rdi, 14 ;check if already ace
    je ace_is_one
    call value_of_card
    add r8, rax
    cmp r8, 10
    jg ace_is_one
    mov rax, 11
    ret
    ace_is_one:
        mov rax, 1
        ret
        

global is_blackjack
is_blackjack:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a blackjack, and FALSE otherwise
    mov r8, rdi ;first card r8
    mov r9, rsi ;second card r9
    call higher_card
    mov rdi, rax
    call value_of_card
    cmp rax, 10
    je check_ace_card
    mov rax, FALSE
    ret
    check_ace_card:
        cmp r8, CA
        je match
        cmp r9, CA
        je match
        mov rax, FALSE
        ret
    match:
        mov rax, TRUE
        ret

global can_split_pairs
can_split_pairs:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards can be split into two pairs, and FALSE otherwise
    call value_of_card
    mov rbx, rax
    mov rdi, rsi
    call value_of_card
    cmp rax, rbx
    je can_split
    mov rax, FALSE
    ret
    can_split:
        mov rax, TRUE
        ret

global can_double_down
can_double_down:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a hand that can be doubled down, and FALSE otherwise
    call value_of_card
    mov rbx, rax
    mov rdi, rsi
    call value_of_card
    add rbx, rax
    cmp rbx, 9
    je can_d
    cmp rbx, 10
    je can_d
    cmp rbx, 11
    je can_d
    mov rax, FALSE
    ret
    can_d:
        mov rax, TRUE
        ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
