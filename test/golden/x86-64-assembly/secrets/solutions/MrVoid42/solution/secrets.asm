; Everything that comes after a semicolon (;) is a comment
PRIVATE_KEY equ 0b1011_0011_0011_1100

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global extract_higher_bits
extract_higher_bits:
    ; This function has a 16-bit integer as argument.
    ; it returns the higher 8-bit value of the argument.
    shr rdi, 8
    mov rax, rdi
    ret

; TODO: define the 'extract_lower_bits' function.
global extract_lower_bits
extract_lower_bits:
    shl rdi, 8
    mov rax, rdi
    shr rax, 8
    ret
; This function takes one 16-bit integer as argument and must return the lower 8-bit value of it.

; TODO: define the 'extract_redundant_bits' function.
global extract_redundant_bits
extract_redundant_bits:
; This function takes one 16-bit integer as argument.
; It returns a 8-bit integer with all bits set in both the lower and the higher 8 bits of the argument.
    mov al, dil
    shr di, 8
    and al, dil
    ret


; TODO: define the 'set_message_bits' function.
global set_message_bits
set_message_bits:
    mov al, dil
    shr di, 8
    or al, dil
    ret  
; This function takes one 16-bit integer as argument.
; It returns a 8-bit integer with all bits set if they are set in the higher 8 bits of the argument, the others unchanged.

; TODO: define the 'rotate_private_key' function.
global rotate_private_key
rotate_private_key:
    call extract_redundant_bits
    movzx cx, al
    popcnt cx, cx
    mov ax, PRIVATE_KEY
    rol ax, cl
    ret
; This function takes one 16-bit integer as argument.
; It returns a 16-bit integer with bits of the private key rotated to the left a number of positions equal to the redundant bits.
; The private key is 0b1011_0011_0011_1100.
; A bit is redundant when it is set in both the lowest 8-bit portion of the argument and the highest 8-bit portion of the argument.

; TODO: define the 'format_private_key' function.
global format_private_key
format_private_key:
    call rotate_private_key
    mov di, ax
    shr di, 8
    xor al, dil
    not al
    ret
; This function takes one 16-bit integer as argument.
; It returns a 8-bit integer with the private key fully formatted.
; To format a private key, you must:
; - Rotate it.
; - Isolate the lowest 8-bit portion of the rotated private key, which is the base value.
; - Isolate the highest 8-bit portion of the rotated private key, which is a mask to be applied to the base value.
; - Flip set bits in the base value that are also set in the mask.
; - Flip all bits in the result.

; TODO: define the 'decrypt_message' function
global decrypt_message
decrypt_message:
    mov r8w, di
    call format_private_key
    shl ax, 8
    mov di, r8w
    call set_message_bits
    ret
    
; This function takes one 16-bit integer as argument
; It returns a 16-bit integer, of which:
; - The higher 8 bits are the formatted private key, according to 'format_private_key'
; - The lower 8 bits are the message with all bits set, according to 'set_message_bits'

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
