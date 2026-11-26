section .text
global allergic_to
allergic_to:
	xor eax, eax
	bts esi, edi
	setc al
    ret


global list
list:
	xor eax, eax					; Initialize count.
	xor ecx, ecx					; Initialize index.

%assign i 0
%rep 8
	xor edx, edx
	mov dword [rsi + 4 + 4*rax], i
	test edi, 1 << i
	setnz dl
	add eax, edx
%assign i i + 1
%endrep

	mov [rsi], eax					; Store final count.
    ret


list_looping:
	xor eax, eax					; Initialize count.
	xor ecx, ecx					; Initialize index.
.loop:
	test edi, 1						; If the low order bit is zero,
	jz .next						; continue to next allergen.
	mov [rsi + 4 + 4*rax], ecx		; Otherwise write to output.
	inc eax
.next:
	shr edi, 1
	inc ecx
	cmp ecx, 8
	jne .loop
	mov [rsi], eax					; Store final count.
    ret
