section .text

global front_door_response
front_door_response:
    ; This function takes the address in memory for a line of the poem as an argument.
    ; It returns the first letter of that line, as a ASCII-encoded character.
    
    mov al, byte [rdi]
    ret

global front_door_password
front_door_password:
    ; This function takes as argument the address in memory for a string containing the combined letters you found in task 1.
    ; It must modify this string in-place, making it correctly capitalized.
    ; The function has no return value.

    mov r8, rdi
    mov dil, byte [r8]
    call capitalize
    mov byte[r8], al
    inc r8
.loop:
    mov dil, byte [r8]
    cmp dil, 0
    je .end
    call lowercase
    mov byte[r8], al
    inc r8
    jmp .loop
.end:

    ret

global back_door_response
back_door_response:
    ; This function takes as argument the address in memory for a line of the poem.
    ; It returns the last letter of that line that is not a whitespace character, as a ASCII-encoded character.

    ; r8 - address
    ; r9b - last valid letter

    mov r8, rdi
    mov r9b, '!'
    dec r8
.loop:
    inc r8
    mov dil, byte [r8]
    cmp dil, 0
    je .end
    call is_letter
    cmp al, 1
    jne .loop
    mov r9b, dil
    jmp .loop
.end:
    mov al, r9b
    ret

global back_door_password
back_door_password:
    ; This function takes as arguments, in this order:
    ; 1. The address in memory for a buffer where the resulting string will be stored.
    ; 2. The address in memory for a string containing the combined letters you found in task 3.
    ; It should store the polite version of the capitalized password in the buffer.
    ; A polite version is correctly capitalized and has ", please." added at the end.
    ; The function has no return value.
    
    mov r8, rsi
    mov r9, rdi
    mov dil, byte [r8]
    call capitalize
    mov byte[r9], al
    inc r8
    inc r9
    lea r10, [rel polite]
.write_loop:
    mov dil, byte [r8]
    cmp dil, 0
    je .polite_loop
    call lowercase
    mov byte[r9], al
    inc r8
    inc r9
    jmp .write_loop
.polite_loop:
    mov r8b, byte[r10]
    mov byte[r9], r8b
    cmp r8b, 0
    je .end
    inc r9
    inc r10
    jmp .polite_loop
.end:

    ret

capitalize:
    ; dil - ascii character
    ; out al - ascii character as capital letter if not already capital

    call is_capital_letter
    cmp al, 1
    je .end
    sub dil, 32

.end:
    mov al, dil
    ret

lowercase:
    ; dil - ascii character
    ; out al - ascii character as lowercase letter if not already lowercase

    call is_lowercase_letter
    cmp al, 1
    je .end
    add dil, 32

.end:
    mov al, dil
    ret

is_capital_letter:
    ; dil - ascii character
    ; out al - 1 if dil is in range 65..=90, else 0

    cmp dil, 'A'
    jb .false
    cmp dil, 'Z'
    jb .true

.false:
    mov al, 0
    ret
.true:
    mov al, 1
    ret

is_lowercase_letter:
    ; dil - ascii character
    ; out al - 1 if dil is in range 97..=122, else 0

    cmp dil, 'a'
    jb .false
    cmp dil, 'z'
    jb .true

.false:
    mov al, 0
    ret
.true:
    mov al, 1
    ret

is_letter:
    ; dil - ascii character
    ; out al - 1 if dil is in range A-Z|a-z

    call is_lowercase_letter
    cmp al, 0
    jne .true
    call is_capital_letter
    cmp al, 0
    jne .true

    mov al, 0
    ret

.true:
    mov al, 1
    ret

section .data
    polite db ", please.", 0


%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
