section .text
global transform

transform:
    ; Arguments:
    ; rdi: NewMapEntry *output
    ; rsi: const LegacyMap *input
    ; rdx: size_t input_size

    ; This function uses a lookup table on the stack to map 
    ; alphabetic indices (0-25) to scores.
    ; This approach naturally sorts the output by character.

    ; Stack layout:
    ; We need space for 26 integers (scores).
    ; 26 * 4 bytes = 104 bytes.
    ; Stack Alignment:
    ; On entry, (rsp + 8) is a multiple of 16.
    ; rsp is congruent to 8 mod 16.
    ; sub rsp, 104 -> 104 is 0x68.
    ; (8 - 104) = -96 = -6*16. 
    ; So rsp becomes 16-byte aligned.
    sub rsp, 104

    ; Initialize the lookup table on the stack to -1.
    ; We use -1 to indicate that a letter has not been encountered.
    ; We use r10 to preserve the output pointer (rdi) during memset.
    mov r10, rdi            
    
    mov rdi, rsp            ; Destination: Stack pointer
    mov eax, -1             ; Value: -1 (0xFFFFFFFF)
    mov rcx, 26             ; Count: 26 dwords
    rep stosd               ; Fill
    
    mov rdi, r10            ; Restore output pointer

    ; Check if input array is empty
    test rdx, rdx
    jz .generate_output

.input_loop:
    ; LegacyMap structure:
    ; offset 0: int32_t key (score)
    ; offset 4: uint8_t values_size (count)
    ; offset 5: char values[26] (letters)
    ; size: 32 bytes (aligned)

    mov eax, [rsi]          ; Load score
    movzx ecx, byte [rsi+4] ; Load letter count
    lea r8, [rsi+5]         ; Load pointer to letters array

    test ecx, ecx
    jz .next_struct         ; Skip if no letters in this group

.letter_loop:
    movzx r9d, byte [r8]    ; Load character
    
    ; Convert to lowercase.
    ; 'A' is 0x41 (01000001), 'a' is 0x61 (01100001).
    ; ORing with 0x20 sets the 6th bit, forcing lowercase.
    or r9b, 0x20
    
    ; Calculate 0-based index ('a' -> 0)
    sub r9b, 'a'
    
    ; Store the score in our stack table at the calculated index.
    ; Since we write by index 0-25, we handle duplicates implicitly (last wins),
    ; though problem implies one-to-one mapping eventually.
    ; r9 was zero-extended by movzx, so safe to use as index.
    mov [rsp + r9*4], eax
    
    inc r8                  ; Move to next char in LegacyMap
    dec ecx
    jnz .letter_loop

.next_struct:
    add rsi, 32             ; Advance to next LegacyMap struct (sizeof=32)
    dec rdx
    jnz .input_loop

.generate_output:
    ; Iterate through our stack table (0-25 / a-z) to generate output.
    ; Since we iterate 0 to 25, the output is automatically sorted.
    
    xor rax, rax            ; rax: Count of items written (return value)
    xor rcx, rcx            ; rcx: Loop index (0..25)

.output_loop:
    mov r8d, [rsp + rcx*4]  ; Load score for current letter index
    
    ; Check if score is valid (not -1)
    cmp r8d, -1
    je .skip_write

    ; Construct NewMapEntry
    ; struct NewMapEntry { char key; int32_t value; }
    ; Alignment: char at 0, padding at 1-3, int32 at 4. Total 8 bytes.
    
    ; Calculate ASCII character: index + 'a'
    lea r9d, [rcx + 'a']
    
    ; We can write the whole struct as a single 64-bit write.
    ; We want the memory to look like: [key][pad][pad][pad][score...]
    ; Little Endian: Low bytes are key, High bytes are score.
    
    ; Shift score (r8) to upper 32 bits of 64-bit register
    shl r8, 32
    
    ; Combine with key (r9) in lower 8 bits.
    ; r9 upper bits are zero from lea logic on 32-bit reg.
    or r8, r9
    
    mov [rdi], r8           ; Write entry to output buffer
    
    add rdi, 8              ; Advance output buffer
    inc rax                 ; Increment item count

.skip_write:
    inc rcx
    cmp rcx, 26
    jne .output_loop

    ; Cleanup stack
    add rsp, 104
    ret