section .text
global clean
clean:
    ; Provide your implementation here
    mov rdx, rdi
    xor ecx, ecx
    xor eax, eax
.loop:
    lodsb
    test al, al
    jz .done
    cmp al, '0'
    jb .loop
    cmp al, '9'
    ja .loop    

    test ecx, ecx
    jz .first_digit
    js .after_country_code
    cmp ecx, 3
    je .must_29
    cmp ecx, 10
    jge .bailout

.continue:
    stosb
    inc ecx
    jmp .loop

.first_digit:
    cmp al, '1'
    ja .continue
    jb .bailout
    mov ecx, -1
    jmp .loop

.after_country_code:
    xor ecx, ecx
.must_29:
    cmp al, '2'
    jae .continue
.bailout:
    mov byte [rdx], 0
    ret
    
.done:
    cmp ecx, 10
    jne .bailout
    mov byte [rdi], 0
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
