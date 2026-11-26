section .text    
global distance
distance: ;(rdi(firstDNA),rsi(secondDNA))
    ; Provide your implementation here
    xor rax,rax ;reset to 0.
loop:
    mov cl,byte[rdi]
    mov dl,byte[rsi]
    test cl,cl
    jz end
    test dl,dl
    jz end
    inc rdi
    inc rsi
    cmp cl,dl
    je next_iter
    inc rax
next_iter:
    jmp loop

end:
    ;At this point a valid compare should have [rdi] == [rsi]
    cmp cl,dl
    je myreturn
    mov rax,-1
myreturn:
    ret
