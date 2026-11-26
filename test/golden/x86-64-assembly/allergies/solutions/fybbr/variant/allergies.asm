; struct item_list {
;    int size;
;    enum item items[MAX_ITEMS];
; };

struc item_list
     .size   resb  4
     .items  resb 32		; 8 items * 4 bytes
endstruc

section .text
global allergic_to
allergic_to:
    ; rdi <- enum item (from 0 to 7) 
    ; rsi <- unsigned int score 
    ; rxa <- extern int <- returns true (1) or false (0)
    
    ; enum item and scores
    ; egg		0	00000001
    ; peanuts		1	00000010
    ; shellfish		2	00000100
    ; strawberries	3	00001000
    ; tomatoes		4	00010000
    ; chocolate		5	00100000
    ; pollen		6	01000000
    ; cats		7	10000000

    mov   rax, 1
    mov   cl, dil					; copy item to cl
    shl   rax, cl					; rax = 2^item => item bit mask
    and   rax, rsi	 				; test if any score bit is part of the the item mask 
    ret

global list
list:
    ; rdi <- unsigned int score
    ; rsi <- struct item_list *list
    ; rxa <- void

    mov   dword [rsi + item_list.size], 0		; init list size
    mov   ecx, 8					; loop counter
    xor   r9, r9					; items index

.loop:
    mov   al, dil					; copy score
    and   al, 1						; test current score bit
    cmp   al, 1						; if one, then has that allergie
    jne   .continue
    mov   eax, 8
    sub   eax, ecx					; find current item enum index (enum item = 8 - cl)
    mov   dword [rsi + item_list.items - r9], eax	; copy item to items list
    add   r9, 4						; increment items index
    inc   dword [rsi + item_list.size]			; increment list size

.continue:
    shr   dil, 1					; move to next score bit
    loop  .loop

    ret

