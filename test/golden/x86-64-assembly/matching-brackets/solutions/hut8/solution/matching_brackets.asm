section .text
global is_paired
is_paired:
    ; int is_paired(const char *str);
    ; rdi = str

    lea rsi, [rel pairs]
    add rsi, ')'
    mov byte [rsi], '('
    
    lea rsi, [rel pairs]
    add rsi, '}'
    mov byte [rsi], '{'

    lea rsi, [rel pairs]
    add rsi, ']'
    mov byte [rsi], '['

    ;; pairs: () {} []

    ;; rcx is the count of pushes
    ;; keep track as to not mangle the stack
    xor rcx, rcx

.proc_char:
    xor rax, rax
    mov al, [rdi]
    test al, al
    jz .check_success

    cmp al, ')'
    je .pop_pair
    cmp al, '}'
    je .pop_pair
    cmp al, ']'
    je .pop_pair

    cmp al, '('
    je .push_pair
    cmp al, '{'
    je .push_pair
    cmp al, '['
    je .push_pair

    ; other chars are to be ignored

.next_char:
    inc rdi
    jmp .proc_char
.push_pair:
    push ax
    inc rcx
    jmp .next_char
.pop_pair:
    test rcx, rcx ; if we're about to pop nothing, bail!
    jz .failure
    
    dec rcx ; decrement how many chars have we stacked
    xor r8, r8 ; clear out r8
    pop r8w ; move (hopefully matching) opening bracket into r8b
    lea rsi, [rel pairs] ; look up base of correct matching brackets
    add rsi, rax ; move to correct matching bracket
    mov r9b, byte [rsi] ; get correct matching bracket in r9b
    cmp r9b, r8b ; compare current char to correct bracket
    jne .failure ; if we got the wrong one, bail
    jmp .next_char ; if we got the right one, continue
.check_success:
    test rcx, rcx
    jz .success
    jmp .failure
.success:
    mov rax, 1
    jmp .unwind
.failure:
    xor rax, rax
    jmp .unwind
.finish:
.unwind:
    test rcx, rcx
    jz .unwind_done
    pop r9w
    dec rcx
    jmp .unwind
.unwind_done:
    ret

section .data
    pairs times 256 db 0