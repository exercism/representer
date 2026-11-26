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
    cmp dil, C10
    jg .face_card
        mov al, dil ; use card value
        ret
    .face_card:
        cmp dil, CA
        je .ace
        mov al, 10
        ret
    .ace:
        mov al, 1
        ret

get_card_pair_values:
    call value_of_card
    mov bl, al
    mov dil, sil
    call value_of_card
    mov dl, al
    mov al, bl
    ret

global higher_card
higher_card:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return which card has the higher value
    ; If both have the same value, both should be returned
    ; If one is higher, the second one should be 0

    ; save cards
    mov r12b, dil
    mov r13b, sil 
    call get_card_pair_values
    mov bl, dl

    ; clear rdx
    xor rdx, rdx
    
    cmp al, bl
    jz .equal
    jl .less
    
    .greater:
        mov al, r12b 
        ret
    
    .less:
        mov al, r13b
        ret

    .equal:
        mov al, r12b
        mov dl, r13b
        ret

global value_of_ace
value_of_ace:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return the value of an upcoming ace

    ; check for aces
    cmp dil, CA
    jz .has_ace
    cmp sil, CA
    jz .has_ace

    ; sum cards
    call get_card_pair_values
    add al, dl
    ; can it be 11?
        cmp al, C10
        ja .no_11
        mov al, 11
        ret
    .has_ace:
    .no_11:
        mov al, 1
        ret

global is_blackjack
is_blackjack:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a blackjack, and FALSE otherwise
    .check_first_is_ace:
        cmp dil, CA
        jz .first_is_ace
    .check_second_is_ace:
        cmp sil, CA
        jz .second_is_ace
        jmp .no
    .first_is_ace:
        cmp sil, C9
        jna .no
        cmp sil, CA ; another ace
        jz .no
        jmp .yes ; it's a 10+ card
    .second_is_ace:
        cmp dil, C9
        jna .no
        jmp .yes
    .no:
        mov al, FALSE
        ret
    .yes:
        mov al, TRUE
        ret
    ret

global can_split_pairs
can_split_pairs:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards can be split into two pairs, and FALSE otherwise

    call get_card_pair_values
    cmp al, dl
    jz .can_split
    .cant:
        mov rax, FALSE
        ret
    .can_split:
        mov rax, TRUE
        ret

global can_double_down
can_double_down:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a hand that can be doubled down, and FALSE otherwise

    call get_card_pair_values
    add al, dl
    cmp al, 8
    jna .no_double_down ; not 9 or above
    cmp al, 12
    jnb .no_double_down ; not 11 or below
    .double_down:
        mov rax, TRUE
        ret
    .no_double_down:
        mov rax, FALSE
        ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
