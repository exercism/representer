default rel

section .data

sentence1: db "For want of a ",0
sentence2: db " the ",0
sentence3: db " was lost.",10,0
sentence4: db "And all for the want of a ",0
sentence5: db ".",10,0

section .text
global copystrings
copystrings: ; rsi source, rdi dest
loop1:
    cmp byte[rsi],0
    jz  workdone
    mov al,[rsi]
    mov [rdi],al
    inc rsi
    inc rdi
    jmp loop1
workdone:
    mov byte[rdi],0
    ret

global recite
recite:

    mov rbx,rsi
    mov rdx,rsi
.reciteloop:
    cmp qword[rbx],0
    je  .end
    cmp qword[rbx-8],0
    je  .lastsentence
    lea rsi,[sentence1]
    call copystrings
    mov rsi,[rbx]
    call copystrings
    add rbx,8
    lea rsi,[sentence2]
    call copystrings
    mov rsi,[rbx]
    call copystrings
    lea rsi,[sentence3]
    call copystrings
    jmp .reciteloop
.lastsentence:
    lea rsi,[sentence4]
    call copystrings
    mov rsi,[rdx]
    call copystrings
    lea rsi,[sentence5]
    call copystrings
.end:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
