; Everything that comes after a semicolon (;) is a comment

WEIGHT_OF_EMPTY_BOX equ 500
TRUCK_HEIGHT equ 300
PAY_PER_BOX equ 5
PAY_PER_TRUCK_TRIP equ 220

section .text

global get_box_weight
get_box_weight:
;; Functin signature:
;;
;;   uint32_t get_box_weight(uint16_t count_first, uint16_t weight_first,
;;                           uint16_t count_second, uint16_t weight_second);
;;    
;; Parameters:
;;    
;;   di: uint16_t, the number of items for the first product in the
;;   box
;;
;;   si: uint16_t, the weight of each item of the first product, in
;;   grams
;;
;;   dx: uint16_t, the number of items for the second product in the
;;   box
;;
;;   cx: uint16_t, the weight of each item of the second product, in
;;   grams
;;    
;; Return value:
;;    
;;   eax: uint32_t, the total weight of a box, in grams
    ; Calculate the weight of the first box.
    ; edi = di * si
    movzx edi, di
    movzx esi, si
    imul edi, esi
    ; Calculate the weight of the second box.
    ; edx = dx * cx
    movzx edx, dx
    movzx ecx, cx
    imul edx, ecx
    ; Take the sum of the weights of the items and the box.
    ; eax = edi + edx 
    lea eax, [rdx + rdi + WEIGHT_OF_EMPTY_BOX]
    ret
global max_number_of_boxes
max_number_of_boxes:
;; Function signature:
;;
;;   uint8_t max_number_of_boxes(uint8_t box_height);
;;    
;; Parameters:
;;
;;   dil: uint8t, the height of the box, in centimeters.
;;
;; Return value:
;;
;;  al: uint8_t, how many boxes can be stacked vertically in a TRUCK_HEIGHT-tall truck
;;
    ; edx:eax = TRUCK_HEIGHT
    xor edx, edx
    movzx eax, al
    mov eax, TRUCK_HEIGHT
    ; eax = edx:eax / edi = TRUCK_HEIGHT / edi
    div edi
    ret

global items_to_be_moved
items_to_be_moved:
;; Function signature:
;;
;;  int32_t items_to_be_moved(uint32_t remaining_items, uint32_t items_in_box);
;;
;; parameters:
;;
;;   edi: uint32_t, the number of items still unaccounted for a
;;     product
;;
;;   esi: uint32_t, the number of items for the product in a box
;;
;; Return value:
;;
;;   eax: int32_t, how many items remain to be moved, after counting
;;     those in the box, i.e., edi - esi. The value can be negative in
;;     case the passed parameters are in error.
    ; eax = edi - esi
    mov eax, edi
    sub eax, esi
    ret

global calculate_payment
calculate_payment:
;; Function signature:
;;
;;    int64_t calculate_payment(uint64_t upfront_payment,
;;                              uint32_t boxes_moved,
;;                              uint32_t num_trips,
;;                              uint32_t lost_items,
;;                              uint64_t value_of_each_lost_item,
;;                              uint8_t num_of_workers);
;;
;; parameters:
;;
;;   rdi: uint64_t, the upfront payment
;;
;;   esi: uint32_t, the total number of boxes moved
;;
;;   edx: uint32_t, the number of truck trips made
;;
;;   ecx: uint32_t, the number of lost items
;;
;;   r8: uint64_t, the value of each lost item
;;
;;   r9b: uint8_t, the number of other workers to split the
;;     payment/debt with you
;;
;; Return value:
;;
;;   rax: int64_t, how much you should be paid, or pay, at the end,
;;   assuming that you get your share and also the remainder of the
;;   division.
    ; Calculate the box pay.
    ; rsi = esi* PAY_PER_BOX
    mov esi, esi               ; Zero out the upper 32 bits of rsi.
    imul rax, rsi, PAY_PER_BOX ; We could use lea here for PAY_PER_BOX = 5.
    ; Calculate the truck-use pay
    ; rdx = edx * PAY_PER_TRUCK_TRIP
    mov edx, edx               ; Zero out the upper 32 bits of rdx.
    imul rdx, rdx, PAY_PER_TRUCK_TRIP
    ; Take the sum of the box and truck pays.
    ; rxa += rdx
    add rax, rdx
    ; Calculate the value of lost items.
    ; rcx = ecx * r8
    mov ecx, ecx               ; Zero out the upper 32 bits of rcx.
    imul rcx, r8
    ; Subtract the value of the lost items and the up front payment
    ; from the total pay.
    ; rax -= rdi + rcx
    sub rax, rdi
    sub rax, rcx
    ; Calculate how much I will receive.
    ; r9b++  (Add myself to the number of workers)
    ; rax = rax / r9b + rax % r9b
    movzx r9, r9b
    lea rsi, [r9 + 1]
    cqo                         ; Convert rax to rdx:rax
    idiv rsi                    ; Divide rdx:raax by r9 and store the
                                ; quotient and the remainder in rax
                                ; and rdx, respectively.
    add rax, rdx
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif