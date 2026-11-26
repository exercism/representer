# asmsyntax=arm64
.text
.globl truncate

// truncate(buffer, input) -> void
truncate:
    stp fp, lr, [sp, -16]!
    mov x9, 0 // utf-8 characters written
    b truncate_sync
truncate_multi:
    ldrb w2, [x1], 1 // read input.byte
    cbz w2, truncate_end // break if null
    strb w2, [x0], 1 // write input.byte
    lsr w3, w2, 6
    cmp w3, 0b10
    b.eq truncate_multi // loop over all continuation bytes
    // at start of next character so backtrack
    sub x1, x1, 1
    sub x0, x0, 2
    add x9, x9, 1 // characters_written++
truncate_sync:
    cmp x9, 5
    b.eq truncate_end // break after 5 runes written
    ldrb w2, [x1], 1 // read input.byte
    cbz w2, truncate_end // break if null
    strb w2, [x0], 1 // write input.byte
    lsr w3, w2, 6 // discard 6 least significant bits
    cmp w3, 0b10 // compare with continuation byte header
    b.ge truncate_multi // read either a start or continuation byte
    add x9, x9, 1 // ascii character read; characters_written++
    b truncate_sync
truncate_end:
    strb wzr, [x0] // write null byte
    ldp fp, lr, [sp], 16
    ret
