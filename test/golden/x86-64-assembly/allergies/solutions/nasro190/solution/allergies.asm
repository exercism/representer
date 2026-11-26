section .text
global allergic_to
allergic_to:
    ; This function checks if the person is allergic to the given substance
    ; Inputs:
    ;   rdi: the index of the substance to check
    ;   rsi: the bit mask of the person's allergies
    ; Outputs:
    ;   rax: 1 if the person is allergic to the substance, 0 otherwise

		; Shift 1 left by the substance index, giving us a bit mask
		mov rcx, rdi
		mov rax, 1
		shl rax, cl
		
		; AND the bit mask with the person's allergy bit mask
		and rax, rsi
		
		; If the result is non-zero, the person is allergic to the substance
    ret
    
global list
list:
    ; This function creates a list of substances the person is allergic to
    ; Inputs:
    ;   rdi: the person's allergy score
    ;   rsi: a pointer to the list array
    ; Outputs:
    ;   rsi: the updated pointer to the list array
    ;   rax: the number of substances the person is allergic to
    
		; Initialize the counters
		xor rcx, rcx
		xor r8, r8
		
		; Loop through the substances
		.loop:
		
		; If we've checked all the substances, we're done
		cmp rcx, 8
		jge .endloop
		
		; Shift 1 left by the substance index, giving us a bit mask
		mov rax, 1
		shl rax, cl
		
		; AND the bit mask with the person's allergy score
		test rdi, rax
		
		; If the result is zero, the person is not allergic to the substance
		je .notallgeric
		
		; Add the substance index to the list
		mov [rsi+r8*4+4], ecx
		inc r8
		
		.notallgeric:
		inc rcx
		jmp .loop
		
		.endloop:
		; Store the number of substances in the first element of the list array
		mov [rsi], r8d
		
		; Return the updated pointer to the list array and the number of substances
    ret
