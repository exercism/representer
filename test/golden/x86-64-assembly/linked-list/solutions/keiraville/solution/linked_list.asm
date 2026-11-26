default rel

; a Node in the doubly linked-list
struc Node
        ; pointer to previous node
        .Prev:  resq    1
        ; pointer to next node
        .Next:  resq    1
        ; int data
        .Data:  resd    1

        .Index:  resd   1
        .Padding:  resq 1
endstruc

; references to start and end of a list
struc List
        ; pointer to First node in the List
        .First  resq    1
        ; pointer to Last node in the list
        .Last   resq    1
endstruc

; this code can be run across different OS
; don't rely on libc or syscalls for memory
; instead rely on the OS to provide
; an arena like allocation in the .bss
section .bss
; store the single instance of List to store pointers to First and Last nodes
list:
        resb List_size
; space for 16 nodes which will be "allocated" sequentially
nodes:
        resb 0x10*Node_size
; an integer that has the next available node from nodes to "allocate"
currnodeidx:
        resq 1


section .text


; void remove_node(struct Node *node) {
;     node->Data = currnodeidx;
;     currnodeidx = node->Index;
;     node->Prev->Next = node->Next;
;     node->Next->Prev = node->Prev;
; }
remove_node:
        lea rcx, currnodeidx
        mov edx, [rcx]
        mov [rdi + Node.Data], edx

        mov edx, [rdi + Node.Index]
        mov [rcx], edx

        mov rdx, [rdi + Node.Next]
        mov rcx, [rdi + Node.Prev]
        mov [rcx + Node.Next], rdx

        mov [rdx + Node.Prev], rcx
        ret


; Node* allocate_node(void) {
;     struct Node *allocated = &nodes[currnodeidx];
;     currnodeidx = nodes[currnodeidx].Data;
;     return allocated;
; }

allocate_node:
        lea r8, nodes
        lea r9, currnodeidx
        xor rdx, rdx
        mov edx, [r9]
        mov rax, Node_size
        mul rdx ; currnodeidx * sizeof(Node)
        add rax, r8
        mov edx, [rax + Node.Data]
        mov [r9], edx
        ret


global list_create

; void list_create(void) {
;     nodes[0].Prev = nodes[0].Next = &nodes[0];
;
;     currnodeidx = 1;
;     for (int i = 1; i <= 15; ++i) {
;         nodes[i].Data = i + 1;
;         nodes[i].Index = i;
;     }
; }

list_create:
        lea r8, nodes
        mov [r8 + Node.Prev], r8
        mov [r8 + Node.Next], r8
        mov edx, 1

.loop_list_create:
        add r8, Node_size
        mov [r8 + Node.Index], edx
        inc edx
        mov [r8 + Node.Data], edx
        cmp edx, 16
        jnz .loop_list_create

        lea r9, currnodeidx
        mov [r9], dword 1
        ret


global list_count

; // counts the items on a list
; size_t list_count(void) {
;     size_t result = 0;
;     // struct Node *current = list.First;
;     struct Node *current = nodes[0].Next;
;     while (current != &nodes[0]) {
;         current = current->Next;
;         ++result;
;     }
;     return result;
; }

list_count:
        mov rax, -1

        lea r8, nodes
        mov rcx, r8

.list_count_loop:
        inc rax
        mov rcx, [rcx + Node.Next]
        cmp rcx, r8
        jnz .list_count_loop

.list_count_return:
        ret


global list_push

; // inserts item at back of a list
; void list_push(int item_data) {
;     struct Node *allocated = allocate_node();

;     nodes[0].Prev->Next = allocated;
;     allocated->Prev = nodes[0].Prev;
;     allocated->Next = &nodes[0];
;     allocated->Data = item_data;
;     nodes[0].Prev = allocated;
; }

list_push:
        call allocate_node
        ; rax is address of allocated node

        lea r8, nodes
        mov r9, [r8 + Node.Prev] ; nodes[0].Prev
        mov [r9 + Node.Next], rax

        mov [rax + Node.Prev], r9

        mov [rax + Node.Next], r8

        mov dword [rax + Node.Data], edi

        mov [r8 + Node.Prev], rax
        ret


global list_pop

; // removes item from back of a list
; int list_pop(void) {
;     int result = nodes[0].Prev->Data;
;     remove_node(nodes[0].Prev);
;     return result;
; }

list_pop:
        lea r8, nodes
        mov rdi, [r8 + Node.Prev]
        mov eax, dword [rdi + Node.Data]
        jmp remove_node


global list_unshift

; // inserts item at front of a list
; void list_unshift(int item_data) {
;     struct Node *allocated = allocate_node();

;     nodes[0].Next->Prev = allocated;
;     allocated->Next = nodes[0].Next;
;     allocated->Prev = &nodes[0];
;     allocated->Data = item_data;
;     nodes[0].Next = allocated;
; }

list_unshift:
        call allocate_node
        ; rax is address of allocated node

        lea r8, nodes
        mov r9, [r8 + Node.Next] ; nodes[0].Next
        mov [r9 + Node.Prev], rax

        mov [rax + Node.Next], r9

        mov [rax + Node.Prev], r8

        mov dword [rax + Node.Data], edi

        mov [r8 + Node.Next], rax
        ret


global list_shift

; // removes item from front of a list
; int list_shift(void) {
;     int result = nodes[0].Next->Data;
;     remove_node(nodes[0].Next);
;     return result;
; }

list_shift:
        lea r8, nodes
        mov rdi, [r8 + Node.Next]
        mov eax, dword [rdi + Node.Data]
        jmp remove_node


global list_delete

; // deletes a node that holds the matching data
; void list_delete(int data) {
;     struct Node *current = nodes[0].Next;
;     while (current != &nodes[0]) {
;         if (current->Data == data) {
;             remove_node(current);
;             return;
;         }
;         current = current->Next;
;     }
; }
list_delete:
        mov rax, rdi
        lea r8, nodes
        mov rdi, r8

.list_delete_loop:
        mov rdi, [rdi + Node.Next]
        cmp rdi, r8
        jz .list_delete_return

        mov edx, dword [rdi + Node.Data]
        cmp edx, eax
        jnz .list_delete_loop

        jmp remove_node

.list_delete_return:
        ret


global list_destroy

; void list_destroy(void)
; {
; }
list_destroy:
        ret
