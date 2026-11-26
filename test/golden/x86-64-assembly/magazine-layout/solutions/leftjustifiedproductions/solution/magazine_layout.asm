%include "debug.mac"
default rel
%ifndef MAGAZINE_LAYOUT_ASM
%define MAGAZINE_LAYOUT_ASM

; Write your macros in this file.
; A helper file includes the current file and calls these macros in predefined functions.
; Keep the names and argument order as given.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Task 1: name the format constants ---
; Give each value a readable name according to the instructions:
; - `COLUMN_COUNT` is `4`
; - `COLUMN_STRIDE` is `18`
; - `SPACE` is `0x20`, the blank byte
; - `RULE` is `0x3D`, the byte `=`
; - `RULE_WIDTH` is `4`
; - `PLAIN` is `0x2E`, the byte `.`
; - `RULED` is `0x2D`, the byte `-`
; - `BOXED` is `0x23`, the byte `#`
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%define COLUMN_COUNT 4
%define COLUMN_STRIDE 18
%define SPACE 0x20
%define RULE 0x3D
%define RULE_WIDTH 4
%define PLAIN 0x2E
%define RULED 0x2D
%define BOXED 0x23
%define COUNTER rcx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Task 2: define the COUNTER and the fill_run macros ---
; The COUNTER name should expand to the rcx register
;
; The fill_run macro fills N slots of an output array with copies of a given byte.
;
; It takes 3 arguments:
; 1. the destination address, passed in a 64-bit general-purpose register.
; 2. the count of bytes (N) to write, passed in a 64-bit general-purpose register or as an immediate.
; 3. the byte to write (always non-negative), passed in an immediate.
;
; The `fill_run` macro may clobber `COUNTER` freely, but no other register.
; It is called three times in two different functions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro fill_run 3
    push rbx ; Save rbx since we will use it as a pointer
    mov COUNTER, %2
    test COUNTER, COUNTER
    jz %%fill_loop_end
    lea rbx, [%1]
%%fill_loop:
    
    mov byte [rbx], %3
    inc rbx
    dec COUNTER
    jnz %%fill_loop
%%fill_loop_end:
    pop rbx ; Restore rbx
%endmacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Task 3: define the lay_columns macro ---
; This macro writes COLUMN_COUNT offsets, each a 64-bit integer, to an output array.
;
; It takes two arguments in this order:
; 1. the destination address, passed in a 64-bit general-purpose register
; 2. the left margin, passed in a 64-bit general-purpose register
;
; The number of offsets to be written to the destination address is fixed and equal to `COLUMN_COUNT`.
; Each offset is a 64-bit value calculated with:
; `offset[i] = margin + i * COLUMN_STRIDE`,
; where `i` is the index of the offset starting at `0`, and `margin` is the second argument.
;
; This macro may clobber its two register arguments, but no other.
; It is called once.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro lay_columns 2
    push rax ; Save rax since we will use it for calculations
    push rbx ; Save rbx since we will use it for calculations
    push rcx ; Save rcx since we will use it as a counter
    push rdx ; Save rdx since we will use it for calculations
    push rdi ; Save rdi since we will use it as a pointer
    push rsi ; Save rsi since we will use it as an index
    push r9 ; Save r9 since we will use it for the left margin
    push r10 ; Save r10 since we will use it for the destination address
    mov COUNTER, COLUMN_COUNT
    mov rdi, %1 ; Move the destination address into rdi
    mov rsi, %2 ; Move the left margin into rsi
    xor r9, r9 ; Clear r9 to use it for the index i
%%lay_columns_loop:
    lea r10, [rdi + r9 * 8] ; Load the destination address into r10
    mov rax, r9 ; Move the index i into rax    
    mov rbx, COLUMN_STRIDE
    mul rbx ; Multiply i by COLUMN_STRIDE    
    add rax, rsi ; Calculate the offset: margin + i * COLUMN_STRIDE
    mov [r10], rax
    inc r9 ; Increment the index i
    dec COUNTER    
    jnz %%lay_columns_loop
    pop r10 ; Restore r10
    pop r9 ; Restore r9
    pop rsi ; Restore rsi
    pop rdi ; Restore rdi
    pop rdx ; Restore rdx
    pop rcx ; Restore rcx
    pop rbx ; Restore rbx
    pop rax ; Restore rax    
%endmacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Task 4: define the set_header macro ---
; This macro adds a header byte to an output memory address, according to a literal style id.
;
; It takes two arguments in this order:
; 1. the destination address.
; 2. a literal style id passed as an immediate, where `0` is plain, `1` is ruled, and `2` is boxed.
;
; The destination address is the expression of an effective memory address.
; It takes a base register that may be summed with:
; - an index register scaled by `1`, `2`, `4` or `8`
; - an immediate
;
; The possible ids and their corresponding header byte are:
;
; | id  | header byte |
; |-----|-------------|
; | 0   | PLAIN       |
; | 1   | RULED       |
; | 2   | BOXED       |
;
; Select the header byte with conditional assembly (`%if` / `%elif` / `%else`).
;
; This macro should not clobber any register.
; It is called three times in the same function.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro set_header 2
;debugd64 rcx
    %if %2 == 0
        mov byte [%1], PLAIN
    %elif %2 == 1
        mov byte [%1], RULED
    %else
        mov byte [%1], BOXED
    %endif
%endmacro
%endif

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
