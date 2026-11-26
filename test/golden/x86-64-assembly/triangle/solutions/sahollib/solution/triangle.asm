%include "debug.mac"
section .text

no_zero_sides:
    mov rax, 1
    mov rsi, qword [rdi]
    or rsi, rsi
    setne dl
    and al, dl
    lea rdi, [rdi+8]
    mov rsi, qword [rdi]
    or rsi, rsi
    setne dl
    and al, dl
    lea rdi, [rdi+8]
    mov rsi, qword [rdi]
    or rsi, rsi
    setne dl
    and al, dl
    ret

is_triangle:
    push rdi
    call no_zero_sides
    pop rdi
    movq xmm0, qword [rdi]
    addsd xmm0, qword [rdi+8]
    ucomisd xmm0, qword [rdi+16]
    seta dl
    and al, dl
    movq xmm0, qword [rdi]
    addsd xmm0, qword [rdi+16]
    ucomisd xmm0, qword [rdi+8]
    seta dl
    and al, dl
    movq xmm0, qword [rdi+8]
    addsd xmm0, qword [rdi+16]
    ucomisd xmm0, qword [rdi]
    seta dl
    and al, dl
    debugu64 rax
    ret

global is_equilateral
is_equilateral:
    ; Provide your implementation here
    mov rdi, rcx
    call is_triangle
    movq xmm0, qword [rcx]        ; Load first side
    ucomisd xmm0, qword [rcx+8]   ; Compare with second side
    sete dl                       ; Set if equal
    and al, dl                    ; And with accumulator
    ucomisd xmm0, qword [rcx+16]  ; Compare with third side
    sete dl
    and al, dl
    ret

global is_isosceles
is_isosceles:
    ; Provide your implementation here
    mov rdi, rcx
    call is_triangle
    mov rsi, rax
    xor rax, rax
    movq xmm0, qword [rcx]        ; Load first side
    ucomisd xmm0, qword [rcx+8]   ; Compare with second
    sete dl                       ; Set result
    or al, dl                     ; Or with accumulator
    ucomisd xmm0, qword [rcx+16]  ; Compare with third
    sete dl
    or al, dl
    movq xmm0, qword [rcx+8]      ; Load second side
    ucomisd xmm0, qword [rcx+16]  ; Compare with third
    sete dl
    or al, dl
    and al, sil
    ret

global is_scalene
is_scalene:
    mov rdi, rcx
    call is_triangle
    movq xmm0, qword [rcx]
    ucomisd xmm0, qword [rcx+8]
    setne dl
    and al, dl
    ucomisd xmm0, qword [rcx+16]
    setne dl
    and al, dl
    movq xmm0, qword [rcx+8]
    ucomisd xmm0, qword [rcx+16]
    setne dl
    and al, dl
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
