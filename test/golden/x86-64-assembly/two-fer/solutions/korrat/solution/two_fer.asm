default rel

section .rodata
msg1: db "One for "
msg2: db ", one for me.", 0
you: db "you", 0

section .text
global two_fer
two_fer:
	push rdi ; Save for later

	mov rdi, rsi
	mov rcx, 8
	lea rsi, [msg1]
	rep movsb ; Copy first part into string

	pop rsi
	push rdi
	cmp rsi, 0
	jne .name
	lea rsi, [you] ; no name given, load "you"

.name:
	mov al, 0
	mov rdi, rsi
	not rcx ; Set exc to all ones
	repnz scasb ; Determine length of name

	not rcx
	dec rcx
	pop rdi
	rep movsb ; Copy name into buffer

	mov rcx, 14
	lea rsi, [msg2]
	rep movsb ; Copy second part into buffer
    ret
