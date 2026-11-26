.text
.globl convert

convert:
	mov x8, x0
	mov x9, #3
	udiv x10, x1, x9
	msub x11, x10, x9, x1
	cbnz x11, 1f
	adrp x10, pling
	add x10, x10, :lo12:pling
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #2
1:	mov x9, #5
	udiv x10, x1, x9
	msub x11, x10, x9, x1
	cbnz x11, 2f
	adrp x10, plang
	add x10, x10, :lo12:plang
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
2:	mov x9, #7
	udiv x10, x1, x9
	msub x11, x10, x9, x1
	cbnz x11, 3f
	adrp x10, plong
	add x10, x10, :lo12:plong
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
	ldrb w11, [x10], #1
	strb w11, [x8], #1
3:	cmp x8, x0
	b.eq .numeric
	strb wzr, [x8]
	ret

.numeric:
	mov x9, xzr
	mov x10, x1
	mov x11, #10
1:	add x9, x9, #1
	udiv x10, x10, x11
	cbnz x10, 1b
	add x8, x8, x9
	strb wzr, [x8], #-1
	mov x9, x1
2:	udiv x10, x9, x11
	msub x12, x10, x11, x9
	add x12, x12, #'0
	strb w12, [x8], #-1
	mov x9, x10
	cbnz x9, 2b
	ret

pling:	.string "Pling"
plang:	.string "Plang"
plong:	.string "Plong"
