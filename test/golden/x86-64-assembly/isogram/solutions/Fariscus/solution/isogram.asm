section .text

; int is_isogram(const char *str);
global is_isogram
is_isogram:
    xor esi, esi         ; Clear esi; use it as a bitmap for the 26 letters
    xor eax, eax         ; Clear eax

.loop:
    mov al, [rdi]        ; Load next letter

    test al, al          ; Check for end of string
    jz .true

.check_uppercase:
    cmp al, 'A'
    jb .next
    cmp al, 'Z'
    ja .check_lowercase
    or al, 0x20          ; Convert to lowercase letter
    jmp .lowercase

.check_lowercase:
    cmp al, 'a'
    jb .next
    cmp al, 'z'
    ja .next

.lowercase:
    sub al, 'a'          ; Convert letter to offset
    bts esi, eax         ; Test and set, the original bit is stored to CF
    jc .false            ; CF == 1 --> The letter has already been seen

.next:
    inc rdi
    jmp .loop

.true:
    mov eax, 1
    ret

.false:
    xor eax, eax
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
