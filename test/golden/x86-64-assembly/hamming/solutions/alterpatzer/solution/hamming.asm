section .text
global distance
; int distance(const char *strand1, const char *strand2)
; return -1 if strands have different lengths, else number of positions
; where they differ.
distance:
    xor eax, eax
.next:
    mov r8b, [rdi]
    mov r9b, [rsi]
    test r8b, r8b
    jz .stop
    test r9b, r9b
    jz .stop
    cmp r8b, r9b
    je .same
    inc eax
.same:
    inc rdi
    inc rsi
    jmp .next
.stop:
    cmp r8b, r9b
    je .done
    mov eax, -1
.done:
    ret
