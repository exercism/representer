; %include "debug.mac"

BOARD_SIZE equ 8

section .text

%macro ABS 2
    ; Compute the absolute value of %1 and put it into %2    
    mov %2, %1
    neg %2
    cmovl %2, %1
%endmacro

global can_create
can_create:
    ; The function has type signature int can_create(int row, int column)
    ; Both arguments and the return value are of int type, which is a 32-bit signed integer
    ; The return value should be set to zero if false and non-zero if true
    %define row edi
    %define col esi

        ; default return value is FALSE
        xor eax, eax
        
        cmp row, BOARD_SIZE
        jae .false

        cmp col, BOARD_SIZE
        jae .false
    
    .true:
        inc eax
    
    .false:
        ret

global can_attack
can_attack:
    ; The function has type signature int can_attack(int white_row, int white_column, int black_row, int black_column)
    ; All arguments and the return value are of int type, which is a 32-bit signed integer
    ; The return value should be set to zero if false and non-zero if true
    %define white_row edi   ; (arg)
    %define white_col esi   ; (arg)
    %define black_row edx   ; (arg)
    %define black_col ecx   ; (arg)
    
    %define delta_row edi
    %define delta_col esi
        
        ; default return value is FALSE
        xor eax, eax

        sub black_row, white_row
        ABS black_row, delta_row

        sub black_col, white_col
        ABS black_col, delta_col

        ; Same row if delta is 0
        test delta_row, delta_row
        jz .true

        ; Same column if delta is 0
        test delta_col, delta_col
        jz .true

        ; Same diagonal if same deltas
        cmp delta_col, delta_row
        je .true

    .false:
        ret
    
    .true:
        inc eax
        ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
