section .text
global two_fer
two_fer:
    ; init buffer with "one for "
    mov   rax, rdi		; save name address
    mov   rdi, rsi		; set movsb destination to buffer address
    lea   rsi, [rel part1]	; set movsb source address
    mov   rcx, part1len		; set the number of bytes to move
    rep movsb			; repeat movsb cx times

    cmp   rax, 0		; is name null?
    je    .no_name

    mov   r8, rax
    mov   rcx, 0 

.use_name:
    ; find lenght of name and
    ; append name to buffer, if name is not null
    inc   cx
    inc   r8
    cmp   byte [r8-1], 0
    jne   .use_name
    dec   cx
    mov   rsi, rax
    rep movsb
    jmp   .end    

.no_name:
    ; append "you" to buffer, if name is null
    lea   rsi, [rel part2]
    mov   rcx, part2len
    rep movsb

.end:
    ; append ", one for me." to buffer
    lea   rsi, [rel part3]
    mov   rcx, part3len
    rep movsb
    mov   byte [rdi], 0
    ret

section .rodata
part1: 	  db 	"One for "
part1len  equ   $-part1

part2: 	  db 	"you"
part2len  equ   $-part2

part3: 	  db 	", one for me."
part3len  equ   $-part3
