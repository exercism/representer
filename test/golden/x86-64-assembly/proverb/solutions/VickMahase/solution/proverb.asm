default rel

section .data
; Text templates
prefix:     db "For want of a ", 0
middle:     db " the ", 0
suffix:     db " was lost.", 10, 0  ; 10 is newline character
last_line:  db "And all for the want of a ", 0
newline:    db 10, 0  ; Just a newline character

section .text
global recite

; Helper function to copy a string (null-terminated)
; Inputs:
;   rdi = destination buffer
;   rsi = source string
; Returns:
;   rax = new position in the destination buffer (after copied string)
copy_string:
    push rbx
    mov rbx, rdi        ; Save destination buffer
    
.loop:
    movzx eax, byte [rsi]   ; Load character from source
    test al, al             ; Check for null terminator
    jz .done
    
    mov [rbx], al           ; Store character in destination
    inc rbx                 ; Move to next position in destination
    inc rsi                 ; Move to next character in source
    jmp .loop
    
.done:
    mov rax, rbx            ; Return new position in buffer
    pop rbx
    ret

; Main function to generate the proverb
; Inputs:
;   rdi = buffer to write proverb into
;   rsi = NULL-terminated array of strings (word list)
recite:
    ; Save registers
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    ; Initialize
    mov r12, rdi        ; r12 = output buffer
    mov r13, rsi        ; r13 = array of strings
    mov r14, r12        ; r14 = current position in output buffer
    
    ; Check if the array is empty (first element is NULL)
    mov rax, [r13]
    test rax, rax
    jz .empty_list
    
    ; Check if there is only one element
    mov rax, [r13 + 8]  ; Check second element
    test rax, rax
    jz .single_element
    
    ; Get the first element (used in the last line)
    mov r15, [r13]      ; r15 = first element
    
    ; Generate each line of the proverb
    xor ebx, ebx        ; rbx = index
    
.line_loop:
    ; Get current word
    mov rsi, [r13 + rbx*8]
    test rsi, rsi
    jz .last_element    ; If NULL, we're done with regular lines
    
    ; Get next word
    mov rsi, [r13 + rbx*8 + 8]
    test rsi, rsi
    jz .last_element    ; If NULL, we need to generate the last line
    
    ; Generate: "For want of a [current] the [next] was lost.\n"
    
    ; Add "For want of a "
    lea rsi, [prefix]
    mov rdi, r14
    call copy_string
    mov r14, rax
    
    ; Add current word
    mov rsi, [r13 + rbx*8]
    mov rdi, r14
    call copy_string
    mov r14, rax
    
    ; Add " the "
    lea rsi, [middle]
    mov rdi, r14
    call copy_string
    mov r14, rax
    
    ; Add next word
    mov rsi, [r13 + rbx*8 + 8]
    mov rdi, r14
    call copy_string
    mov r14, rax
    
    ; Add " was lost.\n"
    lea rsi, [suffix]
    mov rdi, r14
    call copy_string
    mov r14, rax
    
    ; Move to next word
    inc rbx
    jmp .line_loop
    
.last_element:
    ; Generate: "And all for the want of a [first].\n"
    
    ; Add "And all for the want of a "
    lea rsi, [last_line]
    mov rdi, r14
    call copy_string
    mov r14, rax
    
    ; Add first word
    mov rsi, r15
    mov rdi, r14
    call copy_string
    mov r14, rax
    
    ; Add ".\n"
    mov byte [r14], '.'
    inc r14
    mov byte [r14], 10  ; newline
    inc r14
    
    ; Null-terminate the output
    mov byte [r14], 0
    jmp .done
    
.single_element:
    ; Generate only: "And all for the want of a [first].\n"
    
    ; Add "And all for the want of a "
    lea rsi, [last_line]
    mov rdi, r14
    call copy_string
    mov r14, rax
    
    ; Add first word
    mov rsi, [r13]
    mov rdi, r14
    call copy_string
    mov r14, rax
    
    ; Add ".\n"
    mov byte [r14], '.'
    inc r14
    mov byte [r14], 10  ; newline
    inc r14
    
    ; Null-terminate the output
    mov byte [r14], 0
    jmp .done
    
.empty_list:
    ; Just null-terminate the output buffer for empty list
    mov byte [r12], 0
    
.done:
    ; Clean up and return
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif