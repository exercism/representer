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


section .text

global new_car
new_car:
;; Function signature:
;;
;;   struct car_t new_car(short speed, const char name[]);
;;
;; Parameters:
;;
;;   di: int16_t, the speed of the car.
;;
;;   rsi: char*, the name of the car.
;;
;; Return value:
;;
;;   A 16-byte car_t struct in rax and rdx.
;;
;; This function creates a car_t struct using the values given as the
;;   parameters for its speed and name members and set the battery
;;   member to 100 and returns the image of the struct in rax and rdx
;;   registers.
;;
;;   The memory layout of the car_t struct
;;
;;    Offset (bytes)    Member     Size (bytes)
;;   ---------------- ---------- --------------
;;     0x00 : 0x09     name        0x0a (10)
;;     0x0a : 0x0b     speed       0x02 (2)
;;     0x0c : 0x0f     battery     0x04 (4)
;;
;;   The size of the car_t struct is therefore 16 bytes, and it needs
;;   to be algined to be a 4-byte boundary.
;;
;;   We put the first eight bytes of this struct in rax and the
;;   remaining eight bytes in rdx. The x86-64 system is a little
;;   endian. The members of the struct's members must be arranged
;;   accordingly. Let register[a:b] and var[a:b} denote the a-th byte
;;   to b-th byte portions of the register. and var, respectively Then
;;   we should have:
;;    
;;   rax = name[0:7]
;;   rdx[1:0] = name[8:9]
;;   rdx[3:2] = speed
;;   rdx[7:4] = battery (in the IEEE 754 representation of 100)
;;
;; Registers modified by this function: rax, rdi
;;
    ; Clear the upper six bytes of rdi.
    movzx edi, di
    ; Copy the first 8 bytes of the name pointed by rsi to rax.
    mov rax, [rsi]
    ; Copy the last 2 bytes of the name to rdx[1:0] and clear the
    ; upper 6 bytes.
    movzx edx, word [rsi + 8]
    ; Copy di to rdx[3:2].
    shl edi, 16
    or rdx, rdi
    ; Copy 100.0f to rdx[7:4]. The IEEE 754 representation of 100.0f
    ; is 0x42c80000. We recycle rdi here.
    mov rdi, 0x42c8000000000000
    or rdx, rdi
    ret

    
global new_track
new_track:
;; Function signature:
;;
;;   struct track_t new_track(enum surface_t surface, size_t distance);
;;
;; Parameters:
;;
;;   edi: enum surface_t, type of surface of the track (0..3).
;;
;;   rsi: size_t, distance of the track
;;
;; Return value
;;
;;   A 16-byte track_t struct in rax and rdx.
;;
;; This function creates a tack_t struct using the values given as the
;;   parameters for its surface and distance members, and returns the
;;   image of the struct in rax and rdx registers.
;;
;;   The track_t struct's layout is:
;;
;;    Offset (bytes)    Member     Size (bytes)
;;   ---------------- ---------- --------------
;;     0x00 : 0x03     surface      0x08 (4)
;;     0x04 : 0x07     [padding]    0x04 (4)
;;     0x08 : 0x0f     distance     0x08 (8)
;;
;;   Its size 16 bytes, and it needs to be aligned to a 8-byte
;;   boundary.
;;
;;   We put the first eight bytes of this struct in rax and the
;;   remaining eight bytes in rdx. The x86-64 system is a little
;;   endian. The members of the struct's members must be arranged
;;   accordingly. Let register[a:b] and var[a:b} denote the a-th byte
;;   to b-th byte portions of the register. and var, respectively Then
;;   we should have:
;;    
;;   rax[7:4] = 0
;;   rax[3:0] = surface
;;   rdx = distance
;;
;; Registers modified by this function: rax, rdx, rdi
;;
    ; Put the value of edi in rax[3:0] and clear rax[7:4].
    mov eax, edi
    ; Copy the value in rsi to rdx.
    mov rdx, rsi
    ret

global new_race
new_race:
;; Function signature:
;;
;;   struct race_t new_race(struct track_t track, uint8_t num_of_laps);    
;;
;; Parameters:
;;
;;   rdi: struct race_t*, a pointer to the race_t struct. (Because the race_t
;;     struct is 120 bytes as shown below, allocation of the memory
;;     for the returned value (struct race_t) is the caller's
;;     responsibility. The allocated address is passed through rdi.)
;;
;;   rsi:rdx: struct track_t, a track_t struct.
;;
;;   cl: uint8_t, the number of laps of the track.
;;
;; Return value.
;;       
;;   None.
;;
;; This function writes data to the space pointed by rdi as specified
;;   by the following chart.
;;    
;;   The cart_t and track_t structs need to be aligned to a 4-byte and
;;   8-byte boundaries, respectively. The race_t struct's layout is
;;   therefore:
;;
;;    Offset (bytes)     Member               Size (bytes)
;;   ---------------- ---------------------- --------------
;;     0x00 : 0x0f     track (rsi:rdx)         0x10 (16)
;;        0x10         num_of_laps (dl)        0x01 (1)
;;     0x11 : 0x13     [padding]               0x03 (3)
;;     0x14 : 0x73     cars[6]                 0x60 (96)
;;        0x74         num_of_running_cars     0x01 (1)
;;     0x75 :- 0x77    [padding]               0x03 (3)
;;
;;   The size of the race_t struct is 0x78 (120) bytes, and it needs
;;   to be aligned to a 8-byte boundary.
;;
;; Registers modified by this function: rcx
;;
    ; Copy rsi:rdx to *rdi
    mov [rdi], rsi
    mov [rdi + 0x08], rdx
    ; Copy dl to [rdi + 0x10] and clear the three bytes following it.
    mov [rdi + 0x10], cl
    mov byte [rdi + 0x74], 0
    ret	
    
global add_participant
add_participant:
;; Function signature:
;;
;;   bool add_participant(struct race_t *race, struct car_t car);
;;
;; Parameters:
;;
;;   rdi: struct race_t*, a pointer to the race_t struct, to which a
;;     car_t struct is copied if there is space for it.
;;
;;   rsi:rdx: struct car_t, a car_t struct to copy to the race_t
;;     struct pointed by rdi.
;;
;; Return value:
;;
;;   rax: bool, true if the car_t struct is successfully copied; false
;;   otherwise.
;;
;; This function copies the car_t struct in rsi to the cars array in
;;   the race_t struct pointed by rdi and returns true, if the array
;;   is not full. If the array is already full, it returns false.
;;
;; Registers modified in this function: rax, rcx
;;
    ; Set rax to zero (false).
    xor eax, eax
    ; Copy the current number of participants to rcx.
    movzx ecx, byte [rdi + 0x74]
    ; If rcx == 6, return false in rax.
    cmp ecx, 6
    jae .done
    ; Calculate the offset of the next entry in the cars array in
    ; qwords (16 * el) and store it in rcx.
    imul rcx, rcx, 16
    ; The offset of the cars array in the race_t struct is 0x14. Copy
    ; rsi to the location with offset rcx from the start of the
    ; array. Also, copy rdi to the qword following the location.
    mov [rdi + 0x14 + rcx], rsi
    mov [rdi + 0x14 + rcx + 0x08], rdx
    inc byte [rdi + 0x74]
    mov eax, 1
.done:
    ret

global add_race
add_race:
;; Function signature:
;;
;;   void add_race(struct tournament_t *tournament, struct race_t race);
;;
;; Parameters
;;
;;   rdi: struct tournament_t*, a pointer to the tournament_t struct.
;;
;;   stack: struct race_t, a race_t struct whose value this function
;;     adds to the races array in the tournament_t struct pointed by
;;     rdi.
;;
;; Return value:
;;
;;   None.
;;
;; This function appends the race_t struct on the stack to the races
;;   struct pointed by rdi. It is guaranteed that the array is not
;;   full.
;;
;; Here is the layout of the tournament_t struct relative to the
;; lowest end of the struct.
;;
;;    Offset (byte)       Member        Size (bytes)
;;  ---------------- ---------------- ---------------
;;   0x000 : 0x95f    races[20]         0x960 (2400)
;;   0x960 : 0x968    num_of_races      0x08 (8)
;;
;; Each element in the races array is 0x78 (120) bytes. The size of
;; the tournament_t struct is 0x968 bytes and needs to be aligned to a
;; 8-byte boundary.
;;
;; Registers modified in this function: rax, rcx, rsi, rdi
;;
    ; Copy the number of races to rcx.
    mov rcx, [rdi + 0x960]
    ; Increment the number of participants.
    inc qword [rdi + 0x960]
    ; Calculate the offset of the next race entry in the races array
    ; and store the result in rax.
    imul rax, rcx, 0x78
    ; Set rdi to the address of the next entry in the races array.
    lea rdi, [rdi + rax]
    ; set rsi to the address of the race_t struct on the stack.
    lea rsi, [rsp + 8]
    ; Set rcx to the size of the race_t struct in qwords, which is
    mov ecx, 0x78 / 8
    ; Copy the race_t struct on the stack to the next entry in the
    ; races array in the races_t struct.
    ; memcpy(rdi, rsi, rcx * 8);
    rep movsq
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif