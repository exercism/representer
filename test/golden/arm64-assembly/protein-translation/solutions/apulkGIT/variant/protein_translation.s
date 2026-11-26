.data

codons:.string "AUG"
       .byte 0
       .string "UUU"
       .byte 1
       .string "UUC"
       .byte 2
        .string "UUA"
        .byte 2
        .string "UUG"
        .byte 2
        .string "UCU"
        .byte 3
        .string "UCC"
        .byte 3
        .string "UCA"
        .byte 3
        .string "UCG"
        .byte 3
        .string "UAU"
        .byte 4
        .string "UAC"
        .byte 4
        .string "UGU"
        .byte 5
        .string "UGC"
        .byte 5
        .string "UGG"
        .byte 6
        .string "UAA"
        .byte 7
        .string "UAG"
        .byte 7
        .string "UGA"
        .byte 7
        .byte 0

amino0: .string "Methionine"
amino1: .string "Phenylalanine"
amino2: .string "Leucine"
amino3: .string "Serine"
amino4: .string "Tyrosine"
amino5: .string "Cysteine"
amino6: .string "Tryptophan"
amino7: .string "STOP"
aminoacids: .dword amino0
            .dword amino1
            .dword amino2
            .dword amino3
            .dword amino4
            .dword amino5
            .dword amino6
            .dword amino7

.text
.globl proteins

// x0 dest addr, x2 src addr, x4 count
copystrings:
copystrings_loop:
        ldrb w3, [x4], #1
        cbz w3,copystrings_done
        strb w3, [x0], #1
        b.al copystrings_loop
copystrings_done:
        mov w3,'\n'
        strb w3, [x0], #1
        mov w3,#0
        strb w3, [x0]
        ret

proteins:
        stp fp, lr, [sp, -16]!
        mov x6,x0
        eor x3,x3,x3
mainloop:
        ldr x5,=codons
        eor x2,x2,x2
codonloop:
        cmp x2,#3
        b.eq codonfound
        ldrb w3,[x1,x2]
        cbz w3,checkend
        ldrb w4,[x5,x2]
        cbz w4,failure
        cmp w3,w4
        b.ne codonendloop
        add x2,x2,#1
        b.al codonloop
codonendloop:
        add x5,x5,#5
        mov x2,#0
        b.al codonloop
codonfound:
        mov x2,#4
        ldrb w3,[x5,x2]     
        cmp w3,7
        b.eq end
        ldr x4,=aminoacids
        lsl x3,x3,#3
        ldr x4,[x4,x3]
        bl copystrings       
        add x1,x1,#3
        b.al mainloop
checkend:
        cbnz x2,failure
end:
        mov w3,#0
        strb w3,[x0]
        ldp fp, lr, [sp], 16
        ret
failure:
        mov w3,#0
        strb w3,[x6]
        ldp fp, lr, [sp], 16
        ret
