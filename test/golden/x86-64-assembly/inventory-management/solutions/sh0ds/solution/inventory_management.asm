%include "debug.mac"
; Everything that comes after a semicolon (;) is a comment

WEIGHT_OF_EMPTY_BOX equ 500
TRUCK_HEIGHT equ 300
PAY_PER_BOX equ 5
PAY_PER_TRUCK_TRIP equ 220

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global get_box_weight
get_box_weight:
    ; This function takes the following parameters:
    ; - The number of items for the first product in the box, as a 16-bit non-negative integer
    ; - The weight of each item of the first product, in grams, as a 16-bit non-negative integer
    ; - The number of items for the second product in the box, as a 16-bit non-negative integer
    ; - The weight of each item of the second product, in grams, as a 16-bit non-negative integer
    ; The function must return the total weight of a box, in grams, as a 32-bit non-negative integer
    
    mov r8, WEIGHT_OF_EMPTY_BOX         ;start with empty box weight

    imul rdi, rsi                       ;total weight of item1
    add r8, rdi

    imul rdx, rcx                       ;total weight of item2
    add r8, rdx                         ;total weight

    mov rax, r8
    ret


global max_number_of_boxes
max_number_of_boxes:
    ; TODO: define the 'max_number_of_boxes' function
    ; This function takes the following parameter:
    ; - The height of the box, in centimeters, as a 8-bit non-negative integer
    ; The function must return how many boxes can be stacked vertically, as a 8-bit non-negative integer
    movzx bx, dil
    mov ax, TRUCK_HEIGHT
    mov dx, 0
    div bx
    ret

global items_to_be_moved
items_to_be_moved:
    ; TODO: define the 'items_to_be_moved' function
    ; This function takes the following parameters:
    ; - The number of items still unaccounted for a product, as a 32-bit non-negative integer
    ; - The number of items for the product in a box, as a 32-bit non-negative integer
    ; The function must return how many items remain to be moved, after counting those in the box, as a 32-bit integer
    sub edi, esi
    mov eax, edi
    ret

global calculate_payment
calculate_payment:
    ; TODO: define the 'calculate_payment' function
    ; This function takes the following parameters:
    ; - The upfront payment, as a 64-bit non-negative integer, rdi
    ; - The total number of boxes moved, as a 32-bit non-negative integer, rsi
    ; - The number of truck trips made, as a 32-bit non-negative integer, rdx
    ; - The number of lost items, as a 32-bit non-negative integer, rcx
    ; - The value of each lost item, as a 64-bit non-negative integer, r8
    ; - The number of other workers to split the payment/debt with you, as a 8-bit positive integer, r9
    ; The function must return how much you should be paid, or pay, at the end, as a 64-bit integer (possibly negative)
    ; Remember that you get your share and also the remainder of the division

    ;net = boxes * PAY_PER_BOX + trips * PAY_PER_TRUCK_TRIP - up_front - broken_items * item_value

    movsxd rsi, esi
    imul rsi, PAY_PER_BOX
    
    movsxd rax, edx
    imul rax, PAY_PER_TRUCK_TRIP
    
    add rsi, rax
    sub rsi, rdi

    movsxd rcx, ecx
    imul rcx, r8
    sub rsi, rcx

    movzx rax, r9b
    inc rax
    mov rcx, rax

    mov rax, rsi
    cqo
    idiv rcx

    add rax, rdx
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
