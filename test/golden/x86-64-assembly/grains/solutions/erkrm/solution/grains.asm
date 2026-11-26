section .text
global square

square:
    ;rdi contiene la entrada de numaro square
    ;rax contendra la salida del numero de granos

    ; si rdi es <= 0 or > 64, return 0
    cmp rdi, 1
    jl .return_zero
    cmp rdi, 64
    jg .return_zero

    ;calcular 2^(rdi -1)
    dec rdi      ; resta 1 de cero
    mov rax, 1   ; empiezar con 1
    mov rcx, rdi ; mover rdi a rcx para el contador
    shl rax, cl  ; desplaza a la izq rdi-1 veces
    ret

.return_zero:
    xor rax, rax
    ret

global total
total:
    ;rax tendrá la cantidad total de granos en el tablero
    ;Como la suma es 2^64 - 1, establezca todos los bits en rax en 1
    mov rax, -1    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
