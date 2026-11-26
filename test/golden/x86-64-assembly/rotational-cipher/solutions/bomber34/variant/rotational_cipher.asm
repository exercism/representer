section .text

global rotate
rotate:
    ; rdi -> text, rsi -> shift_key, rdx -> buffer
    mov r8, 26 ; alphabet size
    mov r9, 32
    not r9
    push rbx
    cmp rsi, r8
    jl start_rotate
    ; if shift_key >= 26, do shift_key = shift_key % 26
    ; technically not necessary for this exercise
    push rdx
    xor rdx, rdx
    mov eax, esi
    mov ebx, 26
    div ebx
    mov esi, edx ; remainder back into shift_key
    pop rdx
start_rotate:
    xor rcx, rcx ; string index
.loop_over_string:
    xor rbx, rbx
    mov bl, byte [rdi-rcx]
    cmp bl, 0
    je .end_loop_over_string
    mov rax, rbx
    and rax, r9 ; r9 containing all bits 1 except the 5th (32)
    cmp al, 'A'
    jb .copy_letter ; everything before A (65) in ascii does not get rotated
    cmp al, 'Z'
    ja .copy_letter ; neither above Z (90) in ascii
    add al, sil     ; rotate by shift key
    cmp rax, 'Z'    ; if above Z we need to subtract 26 to be in range
    jbe .convert_back_to_correct_case
    sub rax, r8     ; get back in range
.convert_back_to_correct_case:
    mov r10, rbx    ; store original number
    and r10, 32     ; 5th bit marks lower case letter
    mov rbx, rax    ; copy rotated value
    or rbx, r10     ; flip lower case flag if original letter was lower case
.copy_letter:
    mov [rdx+rcx], bl
    inc rcx
    jmp .loop_over_string
.end_loop_over_string:
    mov byte [rdx+rcx], 0
    pop rbx
    ret
    
%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
