.data

text11: .string "This is the house that Jack built.\n"
text12: .string "This is the malt "
text13: .string "This is the rat "
text14: .string "This is the cat "
text15: .string "This is the dog "
text16: .string "This is the cow with the crumpled horn "
text17: .string "This is the maiden all forlorn "
text18: .string "This is the man all tattered and torn "
text19: .string "This is the priest all shaven and shorn "
text110: .string "This is the rooster that crowed in the morn "
text111: .string "This is the farmer sowing his corn "
text112: .string "This is the horse and the hound and the horn "
texts1: .dword text11
        .dword text12
        .dword text13
        .dword text14
        .dword text15
        .dword text16
        .dword text17
        .dword text18
        .dword text19
        .dword text110
        .dword text111
        .dword text112

text212: .string "that belonged to the farmer sowing his corn "
text211: .string "that kept the rooster that crowed in the morn "
text210: .string "that woke the priest all shaven and shorn "
text29: .string "that married the man all tattered and torn "
text28: .string "that kissed the maiden all forlorn "
text27: .string "that milked the cow with the crumpled horn "
text26: .string "that tossed the dog "
text25: .string "that worried the cat "
text24: .string "that killed the rat "
text23: .string "that ate the malt " 
text22: .string "that lay in the house that Jack built.\n"
texts2: .dword text22
        .dword text23
        .dword text24
        .dword text25
        .dword text26
        .dword text27
        .dword text28
        .dword text29
        .dword text210
        .dword text211
        .dword text212

.text
.globl recite

// x0 dest addr, x2 src addr, x4 count
copystrings:
copystrings_loop:
        ldrb w3, [x4], #1
        cbz w3, copystrings_done
        strb w3, [x0], #1
        b.al copystrings_loop
copystrings_done:
        strb w3, [x0]
        ret

recite:
        stp fp, lr, [sp, -16]!
mainloop:
        cmp x1,x2
        b.gt end
        ldr x4,=texts1
        mov x5,#8
        madd x4,x1,x5,x4
        sub x4,x4,#8
        ldr x4,[x4]
        bl copystrings

        ldr x6,=texts2
        mov x5,#8
        madd x6,x1,x5,x6
        cmp x1,#1
        b.eq endofloop
        sub x7,x1,#1
        sub x6,x6,#8
innerloop:
        sub x6,x6,#8
        sub x7,x7,#1
        ldr x4,[x6]
        bl copystrings
        cbnz x7,innerloop
endofloop:
        add x1,x1,#1
        b.al mainloop
end:    
        ldp fp, lr, [sp], 16
        ret
