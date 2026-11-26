%macro strlen 1
	pxor xmm0,xmm0
	pcmpistri xmm0,[%2],00001000b ; compare string with 0 (end of string)
	inc rcx 		      ; rcx + 1 due to 0 index
%endmacro

section .text
global distance
distance:
	; strings given in rdi and rsi
	xor rax,rax ; counter
	strlen rdi
	mov rbx,rcx ; placeholder string1 length
	strlen rsi
	cmp rbx,rcx
	jne differ
	cld
.loop:
	cmpsb
	je .equals
	inc rax
.equals:
	loop .loop
	ret

differ:
	mov rax,-1
	leave
	ret
