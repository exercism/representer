bits 64

section .text
global find_anagrams

find_anagrams:
    ; void find_anagrams(int *is_anagram, const char *candidates[], size_t num_candidates, const char *subject)
    
        ; save some parameters
        mov r10, rdi
        mov r11, rsi

    .for_each_candidate:
        dec edx
        js .done

        mov rdi, [r11 + rdx * 8]
        mov rsi, rcx
        call are_unequal_anagrams
        mov [r10 + rdx * 4], eax
        jmp .for_each_candidate

    .done:
        vzeroupper
        ret

are_unequal_anagrams:
    ; case insensitive
    ; int are_unequal_anagrams(const char * word1, const char * word2)
    ; uses rdi, rsi, rax, r8, r9

        push rdi
        push rsi
        call are_equals
        pop rsi
        pop rdi
        test eax, eax
        jnz .false
        jmp are_anagrams

    .false:
        xor eax, eax
        ret


are_anagrams:
    ; case insensitive
    ; int are_anagrams(const char * word1, const char * word2)
    ; uses rdi, rsi, rax, r8, r9

    ; save parameters
    mov r8, rdi
    mov r9, rsi

    ; count letters of word 1
    sub rsp, 32
    mov rdi, rsp
    mov rsi, r8
    call count_letters
    mov r8, rdi

    ; count letters of word 2
    sub rsp, 32
    mov rdi, rsp
    mov rsi, r9
    call count_letters
    mov r9, rdi

    ; compare counts
    vmovdqu ymm0, [r8]         
    vmovdqu ymm1, [r9]         

    vpcmpeqb ymm0, ymm0, ymm1   ; Compare bytes. Identical bytes become 0xFF, others 0x00
    vpmovmskb eax, ymm0         ; Move the sign bits of ymm0 bytes into EAX (32 bits)

    cmp eax, 0xFFFFFFFF         ; If all 32 bytes matched, EAX will be all 1s (0xFFFFFFFF)
    sete al
    movzx eax, al

    add rsp, 64
    ret 


count_letters:
    ; case insensitive
    ; int count_letters(uint8 counts[32], const char * word)
    ; uses rdi, rsi, rax

        ; set counts to 0
        vpxor ymm0, ymm0
        vmovdqu [rdi], ymm0

        xor eax, eax

    .for_each_char:
        mov al, [rsi]
        test al, al
        jz .done

        and al, ~('a' - 'A')
        sub al, 'A'
        and al, 0b11111
        inc byte [rdi + rax]
        inc rsi
        jmp .for_each_char

    .done:
        ret


are_equals:
    ; case insensitive
    ; int are_equals(const char * word1, const char * word2)
    ; uses rdi, rsi, rax, r8, r9,     
    mov eax, 1

    .for_each_char_pairs:
        mov r8b, [rdi]
        and r8b, ~('a' - 'A')
        mov r9b, [rsi]
        and r9b, ~('a' - 'A')

        cmp r8b, r9b
        jne .false

        test r8b, r8b
        jz .true

        inc rdi
        inc rsi
        jmp .for_each_char_pairs

    .false:
        xor eax, eax

    .true:    
        ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
