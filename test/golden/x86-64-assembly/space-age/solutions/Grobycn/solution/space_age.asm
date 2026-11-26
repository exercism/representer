default rel

section .rodata
planets_orbital_period: dd 0.2408476, 0.61519726, 1.0,	1.8808158, 11.862615, 29.447498, 84.016846, 164.79132


section .text
global age
age:
    ; Provide your implementation here
		; rdi - planet, rsi - second

		lea rdx, [rel planets_orbital_period]
		cvtsi2ss xmm0, rsi
		mov rax, 31557600
		cvtsi2ss xmm1, rax
		mulss xmm1, [rdx + rdi*4]
		divss xmm0, xmm1
		
    ret
