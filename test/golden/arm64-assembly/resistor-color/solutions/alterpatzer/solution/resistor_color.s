.section .rodata
black:	.string "black"
brown:	.string "brown"
red:	.string "red"
orange:	.string "orange"
yellow:	.string "yellow"
green:	.string "green"
blue:	.string "blue"
violet:	.string "violet"
grey:	.string "grey"
white:	.string "white"

.align 8
bands:	.quad black, brown, red, orange, yellow
	    .quad green, blue, violet, grey, white, 0

.text
.globl color_code
.globl colors

color_code:
	adrp x8, bands
	add x8, x8, :lo12:bands
	mov x13, x8
1:	mov x9, x0
	ldr x10, [x8], #8
	cbz x10, .not_found
2:	ldrb w11, [x9], #1
	ldrb w12, [x10], #1
	cbz w11, 3f
	cbz w12, 1b
	cmp w11, w12
	b.eq 2b
	b 1b
3:	cbnz w12, 1b
	sub x8, x8, x13
	lsr x0, x8, #3
    sub x0, x0, #1
	ret
.not_found:
    mov x0, #-1
    ret
    
colors:
	adrp x0, bands
	add x0, x0, :lo12:bands
	ret
