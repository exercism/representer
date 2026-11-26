default rel
section .text
global two_fer
extern strlen
two_fer:
    ;; r8 = name
    ;; r9 = buffer
    ;; r10 = strlen(name)

    ; save the inputs
    mov r8, rdi ; rdi is name (really part of the source)
    mov r9, rsi ; rsi is buffer (really the destination)
    
    ;; copy the first part into the buffer
    cld ; we will copy low to high bytes
    lea rsi, [msg_pre] ; from msg_pre...
    mov rdi, r9 ; to buffer...
    mov rcx, msg_pre_len ; for x bytes...
    rep movsb ; copy repeatedly!

    ;; find length of name for copying purposes
    mov rdi, r8 ; argument 1: name string
    call _namelen
    mov r10, rcx ; save the length into r10

    ;; put destination into rdi
    mov rdi, r9 ; rdi = buffer
    add rdi, msg_pre_len ; buffer + strlen(msg_pre_len)

    test rcx, rcx ; is a name passed in?
    jnz _string_present
    ; no name as passed in, so use "you"
    lea rsi, [msg_name_default] ; source = "you"
    mov rcx, msg_name_default_len ; len = 3
    mov r10, rcx ; save length into r10
    jmp _copy_name
_string_present:
    mov rsi, r8 ; original name
    ; rcx is already set to value of strlen
_copy_name:
    rep movsb

_copy_post:
    push    rbp
    mov     rbp, rsp
    ;; copy ", one for me"
    lea rsi, [msg_post] ; from msg_post...
    mov rdi, r9 ; to buffer...
    add rdi, msg_pre_len ; plus msg_pre_len
    add rdi, r10 ; plus length of name
    mov rcx, msg_post_len ; for x bytes...
    rep movsb ; copy repeatedly!
    ;; return
    pop rbp
    ret ; and we're done with the function!

_namelen:
    ; puts len of [string at rdi] in rcx
    xor rcx, rcx ; rcx = 0
    test rdi, rdi ; if rdi == 0 (null pointer)
    jz __namelen_done ; then return 0
__namelen_loop:
    cmp byte [rdi], 0 ; is the byte at *rdi zero?
    jz __namelen_done ; found the null terminator, exit sub
    inc rcx ; increment length
    inc rdi ; increment address
    jmp __namelen_loop ; check again
__namelen_done:
    ret

section .data
    msg_pre: db "One for "
    msg_pre_len: equ $-msg_pre
    msg_post: db ", one for me.",0
    msg_post_len: equ $-msg_post
    msg_name_default: db "you"
    msg_name_default_len: equ $-msg_name_default