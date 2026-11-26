section .text
global is_valid
is_valid:
  mov     r8, 10
  xor     r9, r9
  xor     rax, rax

loop: 
  mov     al, byte [rdi]
  inc     rdi
  test    rax, rax
  jz      done
  cmp     al, '-'
  je      loop
  cmp     al, 'X'
  je      x_digit
  cmp     al, '0'
  jl      false
  cmp     al, '9'
  jg      false
  sub     al, '0'
  xor     rdx, rdx
  mul     r8
  dec     r8
  add     r9, rax
  jmp     loop

x_digit:
  cmp     r8, 1
  jne     false
  dec     r8
  add     r9, 10
  jmp     done

done:
  cmp     r8, 0
  jne     false
  xor     rdx, rdx
  mov     rax, r9
  mov     r8, 11
  div     r8
  cmp     rdx, 0
  je      true
  jmp     false

false:
  mov     rax, 0
  ret

true:
  mov     rax, 1
  ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
