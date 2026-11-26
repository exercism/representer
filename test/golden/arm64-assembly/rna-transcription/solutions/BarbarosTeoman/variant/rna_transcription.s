.text
.globl to_rna

// void to_rna(char *buffer, const char *dna)
// x0 = buffer (output)
// x1 = dna (input)
to_rna:
        mov x2, #0              // index = 0

.loop:
        ldrb w3, [x1, x2]       // load byte from dna
        cbz  w3, .done          // if null terminator, stop

        // Map DNA -> RNA
        cmp  w3, #'C'
        beq  .putG
        cmp  w3, #'G'
        beq  .putC
        cmp  w3, #'T'
        beq  .putA
        cmp  w3, #'A'
        beq  .putU

        // If unknown char, just copy as-is
        strb w3, [x0, x2]
        b    .next

.putG:
        mov  w4, #'G'
        strb w4, [x0, x2]
        b    .next

.putC:
        mov  w4, #'C'
        strb w4, [x0, x2]
        b    .next

.putA:
        mov  w4, #'A'
        strb w4, [x0, x2]
        b    .next

.putU:
        mov  w4, #'U'
        strb w4, [x0, x2]
        b    .next

.next:
        add  x2, x2, #2
        b    .loop

.done:
        mov  w3, #0             // write null terminator
        strb w3, [x0, x2]
        ret
