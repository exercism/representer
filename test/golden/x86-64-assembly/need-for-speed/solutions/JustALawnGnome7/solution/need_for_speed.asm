default rel

; The functions below make use of the following structs and enum:
;
; struct car_t {
;    char name[10];
;    int16_t speed;
;    float battery;
; };
;
; enum surface_t {
;    ASPHALT,
;    SAND,
;    ICE,
;    CLAY
; };
;
; struct track_t {
;    enum surface_t surface;
;    size_t distance;
; };
;
; struct race_t {
;    struct track_t track;
;    uint8_t num_of_laps;
;    struct car_t cars[6];
;    uint8_t num_of_running_cars;
; };
;
; struct tournament_t {
;    struct race_t races[20];
;    size_t num_of_races;
; };

section .rodata

battery dd 100.0

section .text

global new_car
new_car:
    ; struct car_t new_car(short speed, const char name[]);
    ; It returns a new struct car_t with the values provided.
    ; The starting value for field 'battery' is 100.0.

    ; TOTAL CAR SIZE: 16 bytes (or 0x10 bytes)
    ; ----------------------------------------
    ; car.name    - 10 bytes
    ; car.speed   -  2 bytes
    ; car.battery -  4 bytes

    ; di: speed
    ; rsi: name
    lodsq                    ; Copy the first 8 bytes of `name` into RAX.
    mov edx, dword [battery] ; Copy 100.0f into the first 4 bytes of RDX.
    shl rdx, 16              ; Shift RDX 2 bytes to the left...
    mov dx, di               ; ...and move `speed` into the gap.
    shl rdx, 16              ; Shift RDX 2 bytes to the left...
    mov dx, word [rsi]       ; ...and move the remaining bytes of `name` into the gap.
    ret

global new_track
new_track:
    ; struct track_t new_track(enum surface_t surface, size_t distance);
    ; It returns a new struct track_t with the values provided.
    mov eax, edi ; surface
    mov rdx, rsi ; distance
    ret

global new_race
new_race:
    ; struct race_t new_race(struct track_t track, uint8_t num_of_laps);
    ; It returns a new struct race_t with the values provided.
    ; The starting number of running cars is 0.

    ; TOTAL RACE SIZE: 124 bytes (or 0x7C bytes)
    ; ------------------------------------------
    ; 0x00: race.track.surface (4 bytes)
    ; 0x04: gap (4 bytes)
    ; 0x08: race.track.distance (8 bytes)
    ; 0x10: race.num_of_laps (1 byte)
    ; 0x11: gap (3 bytes)
    ; 0x14: race.cars: 96 bytes = 16 bytes * 6 cars
    ; 0x74: race.num_of_running_cars: 1 byte
    ; 0x75: gap (7 bytes)
    ; 0x7B: last byte

    ; struct race_t new_race(struct track_t track, uint8_t num_of_laps);
    ; rdi: address of new struct to be returned
    ; esi: track.surface
    ; rdx: track.distance
    ; cl: num_of_laps

    mov rax, rdi                ; Copy the address of the new struct into RAX (to be returnend).
    mov dword [rdi], esi        ; Copy `track.surface` into the new struct.
    mov qword [rdi + 0x08], rdx ; Copy `track.distance` into the new struct.
    mov byte [rdi + 0x10], cl   ; Copy `num_of_laps` into the new struct.
    mov byte [rdi + 0x74], 0x0  ; Initialize the new struct's `num_of_running_cars` field to zero.
    ret

global add_participant
add_participant:
    ; bool add_participant(struct race_t *race, struct car_t car);
    ; If there's room for one more participant in the race, the car should be added to the list, updating the counter, and its participation is confirmed.
    ; Otherwise, the race organizers must inform the car's owner that it can't participate this time.

    ; Return false if the race is already full...
    movzx eax, byte [rdi + 0x74] ; eax: race.num_of_running_cars
    cmp al, 0x06
    jz .return_false

    ; ...otherwise, add the given car to the race and return true.
    ; car.name    - 10 bytes
    ; car.speed   -  2 bytes
    ; car.battery -  4 bytes

    ; Place the car's 16 bytes onto the stack, then move them into XMM0.
    mov qword [rsp + 0x18], rsi
    mov qword [rsp + 0x20], rdx
    movdqu xmm0, [rsp + 0x18]

    ; Write the new car (from XMM0) into the race.
    movzx edx, al
    shl rdx, 0x4
    movups [rdi + rdx + 0x14], xmm0

    ; Increment `race.num_of_running_cars` and return true.
    inc byte [rdi + 0x74]
    mov eax, 0x01
    ret

.return_false:
    xor eax, eax
    ret

global add_race
add_race:
    ; void add_race(struct tournament_t *tournament, struct race_t race);
    ; It should add a race to the tournament's array and also update its counter.

    ; struct tournament_t {
    ;    struct race_t races[20];
    ;    size_t num_of_races;
    ; };

    ; tournament: rdi
    ; race: [rsp + 0x8]

    ; Get the address for `tournament.num_of_races`.
    lea rdx, [rdi + (0x78 * 20)]

    ; Load the destination address for the new race into RDI.
    mov rcx, qword [rdx]
    imul rcx, rcx, 0x78
    add rdi, rcx

    ; Load the address for the new race into RSI.
    lea rsi, [rsp + 0x8]

    ; Copy the 0x78 bytes (0x1E qwords) from RSI to RDI.
    mov rcx, 0x1E
    rep movsd

    ; Increment the value of `tournament.num_of_races`.
    inc qword [rdx]
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
