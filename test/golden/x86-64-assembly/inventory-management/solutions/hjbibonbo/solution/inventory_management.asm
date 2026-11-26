; Everything that comes after a semicolon (;) is a comment

WEIGHT_OF_EMPTY_BOX equ 500
TRUCK_HEIGHT equ 300
PAY_PER_BOX equ 5
PAY_PER_TRUCK_TRIP equ 220

section .text

global get_box_weight
get_box_weight:

    movzx edi, di
    movzx esi, si
    imul edi, esi
    movzx edx, dx
    movzx ecx, cx
    imul edx, ecx
    add edx, edi
    mov eax, edx
    add eax, WEIGHT_OF_EMPTY_BOX


    
    ret

global max_number_of_boxes
max_number_of_boxes:
    xor edx, edx
    mov eax, TRUCK_HEIGHT
    div edi
    


    
    ret

global items_to_be_moved
items_to_be_moved:

    sub edi, esi
    mov eax, edi

    ret

global calculate_payment
calculate_payment:
    imul esi, PAY_PER_BOX
    imul edx, PAY_PER_TRUCK_TRIP
    imul rcx, r8
    mov eax, esi
    add eax, edx
    mov eax, eax
    
    sub rax, rcx
    sub rax, rdi
    
    inc r9
    cqo                        
    idiv r9
    
    add rax, rdx

    
    
    

    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
