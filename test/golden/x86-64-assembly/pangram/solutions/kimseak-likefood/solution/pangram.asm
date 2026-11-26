section .bss
letters_used: resb 26

section .text
global is_pangram
is_pangram:
	lea rsi, [rel letters_used]
	mov rdx, rsi
	lea rcx, [rel letters_used + 26]
	dec rdi

init:
	cmp rdx, rcx
	jae loop
	mov byte [rdx], 0
	inc rdx
	jmp init

loop:
	inc rdi
	cmp byte [rdi], 0
	je end
    cmp byte [rdi], 'A'
    jb loop
	cmp byte [rdi], 'Z' + 1
	jb uppercase
	cmp byte [rdi], 'a'
	jb loop
	cmp byte [rdi], 'z' + 1
	jb lowercase
	jmp loop

uppercase:
	xor rax, rax
	mov al, [rdi]
	add rax, rsi
	sub rax, 'A'
	mov byte [rax], 1
	jmp loop

lowercase:
	xor rax, rax
	mov al, [rdi]
	add rax, rsi
	sub rax, 'a'
	mov byte [rax], 1
	jmp loop

end:

check:
	cmp rsi, rcx
	jae success
	cmp byte [rsi], 0
	je failure
	inc rsi
	jmp check

success:
	mov rax, 1
	ret

failure:
	mov rax, 0
    ret