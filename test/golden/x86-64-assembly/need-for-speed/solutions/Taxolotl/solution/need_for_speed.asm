section .text

global new_car
new_car:
    ; This function has signature: struct car_t new_car(short speed, const char name[]);
    ; It returns a new struct car_t with the values provided.
    ; The starting value for field 'battery' is 100.0.
    
    mov rax, 100
    cvtsi2ss xmm0, rax
    mov rax, qword [rsi]

    mov rdx, rdi
    sal rdx, 16
    movd edi, xmm0
    shl rdi, 32
    or rdx, rdi
    ret

global new_track:
new_track:
    ; This function has signature: struct track_t new_track(enum surface_t surface, size_t distance);
    ; It returns a new struct track_t 
    ;   first 32:
    ;       car_t.battery (float, movd into xmm register)
    ;   next 16:
    ;       car_t.speed
    ;   last 16 unusedwith the values provided.

    mov rax, rdi
    mov rdx, rsi
    ret

global new_race:
new_race:
    ; This function has signature: struct race_t new_race(struct track_t track, uint8_t num_of_laps);
    ; It returns a new struct race_t with the values provided.
    ; The starting number of running cars is 0.

    ; rdi - address
    ; rsi - track_t surface
    ; rdx - track_t distance
    ; ecx - num_of_laps

    mov qword [rdi], rsi
    mov qword [rdi + 8], rdx
    mov byte [rdi + 16], cl
    mov byte [rdi + 116], 0
    mov rax, rdi

    ret

global add_participant:
add_participant:
    ; This function has signature: bool add_participant(struct race_t *race, struct car_t car);
    ; If there's room for one more participant in the race, the car should be added to the list, updating the counter, and its participation is confirmed.
    ; Otherwise, the race organizers must inform the car's owner that it can't participate this time.

    ; rdi - address to race_t
    ; rsi - car_t.name
    ; rdx:
    ;   first 32:
    ;       car_t.battery (float, movd into xmm register)
    ;   next 16:
    ;       car_t.speed
    ;   last 16 unused

    movzx rax, byte [rdi + 116]
    cmp rax, 6
    je .no_space
    inc byte [rdi + 116]
    shl rax, 4
    add rdi, rax
    mov qword [rdi + 20], rsi
    mov qword [rdi + 28], rdx
    mov rax, 1

    ret

.no_space:
    mov rax, 0
    ret

global add_race:
add_race:
    ; This function has signature: void add_race(struct tournament_t *tournament, struct race_t race);
    ; It should add a race to the tournament's array and also update its counter.

    mov rax, qword [rdi + 20*120]
    inc qword [rdi + 20*120]
    imul rax, rax, 120

    lea rdi, [rdi + rax]
    lea rsi, [rsp + 8]
    mov rcx, 15

    rep movsq
    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
