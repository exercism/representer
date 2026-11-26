section .text

global square_of_sum
square_of_sum:
    ; Provide your implementation here
    ; sum(n) = n(n+1)/2
    lea rax, [rdi+1]
    imul rax, rdi
    shr rax, 1
    imul rax, rax	; squared
    ret

global sum_of_squares
sum_of_squares:
    ; Provide your implementation here
    ; sum(n^2) = n(n+1)(2n+1)/6
    lea rdx, [rdi+1]		; n+1
    lea rax, [rdx+rdi]	; 2n+1
    imul rax, rdi
    imul rax, rdx
    mov rdx, 0x2aaaaaaaaaaaaaab
    mul rdx		; rdx = rax / 6
    mov rax, rdx
    ret

global difference_of_squares
difference_of_squares:
    ; Provide your implementation here
    ; sum(n^2)-sum(n)^2 = n(n+1)(3n^2-n-2)/12
    mov rcx, rdi
    imul rcx, rcx	; n^2
    lea rax, [rcx+rdi]	; n(n+1)
    imul rcx, rax	; n(n+1)*n^2
    add rdi, 2
    imul rax, rdi	; n(n+1)(n+2)
    mov rdx, 0x5555555555555556
    mul rdx		; rdx = n(n+1)(n+2)/3
    mov rax, rcx
    sub rax, rdx	; n(n+1)(n^2-(n+2)/3)
    shr rax, 2		; n(n+1)(3n^2-n-2)/12
    ret
