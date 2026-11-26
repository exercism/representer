section .text
global distance
distance:
    xor rax, rax
loop:
    mov bl, [rdi]
    mov cl, [rsi]
    mov dl, bl
    xor bl,cl
    jz  same
    test cl,cl
    jz   not_same_length
    test dl, dl
    jz   not_same_length
    inc rax
   
same:
    test cl,cl
    jz   end
    inc rdi
    inc rsi
    jmp loop
    

not_same_length:
    mov rax, -1
end:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
