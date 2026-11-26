; Everything that comes after a semicolon (;) is a comment

; Define the constants 'RED', 'GREEN' and 'BLUE'
; They must be accessible from other source files

; Define the variable 'base_color' with the default value of 0xFFFFFF00
; It must be accessible from other source files
section .data
global RED
RED dd 0xFF000000
global GREEN
GREEN dd 0x00FF0000
global BLUE
BLUE dd 0x0000FF00
global base_color
base_color dd 0xFFFFFF00
global SECONDARY_COLOR_ADDRESS
SECONDARY_COLOR_ADDRESS dq 1
global COMBINED_COLOR_ADDRESS
COMBINED_COLOR_ADDRESS dq 1
section .text

; You should implement functions in the .text section

; the global directive makes a function visible to the test files
global get_color_value
get_color_value:
    ; This function takes the address for a color as parameter
    ; It must return the 32-bit value associated with the color
    mov rax, [rdi]
    ret

global add_base_color:
add_base_color:
    ; TODO: define the 'add_base_color' function
    ; This function takes the address for a color as parameter
    ; It saves the 32-bit value associated with this color in the variable 'base_color'
    ; This variable must be accessible from other source files
    ; This function has no return value
    mov edx, dword [rdi]
    mov [rel base_color], edx
    ret

global make_color_combination
extern combining_function
make_color_combination:
    ; TODO: define the 'make_color_combination' function
    ; This function takes the following parameters:
    ; - The address where the 32-bit value for the combined color should be stored.
    ; - The address of a secondary color in the color table.
    ; It should call 'combining_function' with the 32-bit value for base and secondary colors and store the result in the passed address          
    ; This function has no return value
    mov qword [rel COMBINED_COLOR_ADDRESS], rdi
    mov qword [rel SECONDARY_COLOR_ADDRESS], rsi
    mov edi, dword [rel base_color] 
 
    mov esi, dword [rsi]
    call combining_function
   
    mov rdx, qword [rel COMBINED_COLOR_ADDRESS]
    mov [rdx], eax
    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
