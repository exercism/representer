default rel
section .rodata
D: db 31,28,31,30,31,30,31,31,30,31,30,31
S: db 0,3,2,5,0,3,5,1,4,6,2,4
section .text
global meetup
meetup:
push rdi
push r13
push r14
mov r13d,esi
mov r14d,edx
mov r11d,ecx
mov r10d,r8d
mov eax,esi
cmp edx,3
sbb eax,0
mov r8d,eax
mov r9d,eax
shr eax,2
add r9d,eax
xor edx,edx
mov eax,r8d
mov ecx,100
div ecx
sub r9d,eax
shr eax,2
add r9d,eax
lea rax,[S]
movzx eax,byte[rax+r14-1]
add r9d,eax
inc r9d
xor edx,edx
mov eax,r9d
mov ecx,7
div ecx
add edx,6
mov eax,edx
xor edx,edx
div ecx
lea r8d,[rdx+1]
mov eax,r10d
sub eax,r8d
add eax,7
xor edx,edx
div ecx
lea r9d,[rdx+1]
cmp r11d,5
je .t
cmp r11d,6
je .l
imul eax,r11d,7
lea eax,[rax+r9-7]
jmp .f
.t: lea eax,[r9d+7]
cmp eax,13
jge .f
add eax,7
jmp .f
.l: lea rcx,[D]
movzx r10d,byte[rcx+r14-1]
cmp r14d,2
jne .c
test r13d,3
jnz .c
xor edx,edx
mov eax,r13d
mov ecx,100
div ecx
test edx,edx
jnz .p
test eax,3
jnz .c
.p: inc r10d
.c: mov eax,r10d
sub eax,r9d
xor edx,edx
mov ecx,7
div ecx
imul eax,7
add eax,r9d
.f: mov r10d,eax
mov rdi,[rsp+16]
xor edx,edx
mov eax,r13d
mov ecx,100
div ecx
push rdx
mov ecx,10
xor edx,edx
div ecx
call .w
pop rax
call .o
mov al,'-'
stosb
mov eax,r14d
call .o
mov al,'-'
stosb
mov eax,r10d
call .o
mov byte[rdi],0
pop r14
pop r13
pop rdi
ret
.o: xor edx,edx
div ecx
.w: add al,'0'
stosb
lea eax,[rdx+'0']
stosb
ret
