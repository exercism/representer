section .text
global is_pangram
is_pangram:
        mov         rcx, rsp            ; store stack pointer
        ; the 26 bytes down from stack will record letters
        sub         rsp, 26             ; reserve 26 bytes below the stack
        mov         rsi, rsp            ; now rsi points to the beginning of
                                        ; the reserved area
init:   mov byte    [rsi], 0            ; zero out the reserved area
        inc         rsi
        cmp         rsi, rcx
        jne         init

loop:   movzx       eax, byte [rdi]           ; load input character
        cmp         al, 0
        jz          check               ; if we read zero byte, the input is
                                        ; over
        cmp         al, 'A'
        jl          cont                ; do nothing, if the symbol is before
                                        ; 'A'
        cmp         al, 'z'
        jg          cont                ; do nothing, if the symbol is after
                                        ; 'z'
        cmp         al, 'Z'
        jle         low                 ; the symbol was in 'A'-'Z' range
        cmp         al, 'a'
        jl          cont                ; the symbol was after 'Z' but before
                                        ; 'a' => do nothing
        sub         rax, 'a'            ; 'a'-'z' range; al is now offset from
                                        ; the beginning of the alphabet
        jmp         record
low:    sub         rax, 'A';           ; 'A'-'Z' range; al is now offset from
                                        ; the beginning of the alphabet
record: add        rax, rsp
        mov byte   [rax], 1             ; record that we did encounter this
                                        ; letter
cont:   inc         rdi                 ; move to the next input character
        jmp         loop

check:  mov         rax, 1              ; by default we got pangram
loop2:  mov         dl, [rsp]           ; go through our 26 bytes
        and         al, dl
        jz          out                 ; if one of them is zero, we do not
                                        ; have a pangram
        inc         rsp
        cmp         rsp, rcx
        jne         loop2
out:    mov         rsp, rcx            ; restore stack pointer
        ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
