; Name        : Lasagna
; Author      : Brian Spragge
; Description : Practice assembly pretending to cook lasagna
; Sources     : https://exercism.org/tracks/x86-64-assembly/exercises/lasagna
;               https://exercism.org/tracks/x86-64-assembly/exercises/lasagna/solutions/ErikSchierboom

COOK_TIME equ 40
MIN_PER_LAYER equ 2

section .text

;@return rax: cook-time of lasagna
global expected_minutes_in_oven
expected_minutes_in_oven:
    mov rax, COOK_TIME          ;minutes to cook
    ret

;@param rdi: time lasagna has-been  in oven
global remaining_minutes_in_oven
remaining_minutes_in_oven:
    call expected_minutes_in_oven
    sub rax, rdi                ;should-time - has-time 
    ret

;@return rax: minutes taken to prepare lasagna
;@param  rdi: lasagna layers
global preparation_time_in_minutes
preparation_time_in_minutes:
    mov  rax, rdi               ;layers
    imul rax, MIN_PER_LAYER     ;2min a layer for prep
    ret

;@return rax: time taken so far making this lasagna
;@param  rdi: lasagna layers
;@param  rsi: time lasagna has-been in oven
global elapsed_time_in_minutes
elapsed_time_in_minutes:
    call preparation_time_in_minutes
    add rax, rsi                ;prep time + has-been time
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
