section .text
global distance
distance:
    ; Provide your implementation here
    xor rax,rax
compare:
    cmp byte[rdi],0
    je end
    cmp byte[rsi],0
    je fail
    mov cl,[rdi]
    mov dl, [rsi]
    inc rdi
    inc rsi
    cmp cl,dl
    je compare
    inc rax
    jmp compare
end:
   cmp byte[rsi],0
   jne fail
   ret
fail:
   mov rax,-1
   ret
