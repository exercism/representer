; Everything that comes after a semicolon (;) is a comment

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function
global set_time
set_time:
    mov eax, edi
    ret
; the global directive makes a function visible to the test files
global time_to_make_juice
time_to_make_juice:
    ; This function has one argument, the ID for a juice as a 32-bit number
    ; It returns the time to prepare this juice, as a 32-bit number
    cmp edi, 1
    je id1
    cmp edi, 2
    je id2
    cmp edi, 3
    je id3
    cmp edi, 4
    je id4
    cmp edi, 5
    je id5
    cmp edi, 6
    je id6
    cmp edi, 7
    je id7
    cmp edi, 8
    je id8
    mov edi, 0
    call set_time
    ret
    
    
    
    id1:
        mov edi, 1
        call set_time
        ret
    
    id2:
        mov edi, 3
        call set_time
        ret 
           
    id3:
        mov edi, 3
        call set_time
        ret  
          
    id4:
        mov edi, 4
        call set_time
        ret  
        
    id5:
        mov edi, 5
        call set_time
        ret 
         
    id6:
        mov edi, 4
        call set_time
        ret
          
    id7:
        mov edi, 7
        call set_time
        ret
        
    id8:
        mov edi, 10
        call set_time
        ret          

; TODO: define the 'time_to_prepare' function
; This function has two arguments:
; - An array with the IDs for ordered juices, each ID a 32-bit number
; - The number of ordered juices, also a 32-bit number.
; It returns the total time to prepare all ordered juices, as a 32-bit number
global time_to_prepare
time_to_prepare:
    ; clear accumulator
    xor rcx, rcx
    xor rdx, rdx
    
    mov rdx, rdi
    ; create loop
    ; create label
    
    sum_label:
        ; get time from id
        xor rax, rax
        xor rdi, rdi
        mov edi, dword [rdx] 
        
        call time_to_make_juice
        
        ; add number from address in rdi to rax
        add ecx, eax
        
        ; increment address by 4 bytes
        add rdx, 4
        
        ; dec esi
        sub esi, 1
        
        cmp esi, 0
        
        ; jnz sum_array
        jne sum_label
        
        mov eax, ecx
        ret
        
global get_wedges_given_size
get_wedges_given_size:
    cmp dil, 'S'
    je small
    cmp dil, 'M'
    je medium
    cmp dil, 'L'
    jmp large
    
    
    small:
        mov eax, 6
        ret
    
    medium:
        mov eax, 8
        ret
    
    large:
        mov eax, 10
        ret
    
; TODO: define the 'limes_to_cut' function
; This function takes three arguments:
; - The number of wedges needed, as a 32-bit number.
; - An array with the current supply of limes, each represented by a 8-bit number.
; - The number of limes in the supply, as a 32-bit number.
; It returns the number of limes that need to be cut, as a 32-bit number
global limes_to_cut
limes_to_cut:
   xor rcx, rcx
   xor r8, r8
   xor r10, r10
   mov r10d, edx
   
   ; store number of wedges needed
   mov r8d, edi 
   
   sum_wedges:
        ; clear r9, r9
        xor r9, r9
        xor rdi, rdi
        xor rax, rax

        
        ;  get size from address
        mov r9b, byte [rsi]
        
        ;  get number from size
        mov dil, r9b
        call get_wedges_given_size
        
        ;  add number to sum
        add ecx, eax
        
        ; increment address
        add rsi, 1
        
        sub edx, 1

        ;  compare number of wedges greater than or equal to needed number
        cmp ecx, r8d
        
        ;  if greater jmp to finish
        jge finish
        
        ; if still limes jmp to loop
        cmp edx, 0
        jne sum_wedges
       
    finish:
           xor rax, rax
           sub r10d, edx
           mov eax, r10d
           ret

; TODO: define the 'remaining_orders' function
; This function takes two arguments:
; - The time left in the shift, as a 32-bit number.
; - An array  with the IDs for ordered juices still not prepared, each ID a 32-bit number.
; It returns the number of juices made before the shift ends, as a 32-bit number.
; You may consider that:
; - The array is never empty.
; - The time left in the shift at the beginning is always greater than 0.
; - There are more orders in the array than that which can be prepared before the shift ends.

global remaining_orders
remaining_orders:
    ; time in minutes left in the shift - edi
    ; array of IDs for ordered juices - rsi
    
    ; keep a variable to increment the number of drinks prepared
    
    xor rax, rax
    
    xor rdx, rdx
    
    xor rcx, rcx
    
    mov edx, edi
    
    ; loop label
    find_order:
        ; clear rdi and rax
        xor rdi, rdi
        xor rax, rax
        
        ; find time from id
        mov edi, dword [rsi]
        
        call time_to_make_juice
        
        ; subtract the eax from edx
        sub edx, eax
        
        add ecx, 1
        
        add rsi, 4
        
        cmp edx, 0
        
        jg find_order
    
    xor rax, rax
    mov eax, ecx
    ret
%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
