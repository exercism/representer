            section .text
            extern  sprintf

            global two_fer
two_fer:                                ; Provide your implementation here

            cmp     rdi, 0              ; compare second argument: name, to see whether it is null
            jne     name                ; if name is not null, jump to use name
you:
            lea     rdx, [rel youstr]   ; use "you" as name: third argument
            jmp     dowork              ; jump to dowork to actually call sprintf
name:
            mov     rdx, rdi            ; use first argument() as third argument: name

dowork:
            mov     rdi, rsi            ; use buffer(second argument: rsi) as first argument
            lea     rsi, [rel format]   ; use format(format in .data) as second argument

            ; ref: https://www.agner.org/optimize/optimizing_assembly.pdf
            ; align stack pointer(rsp) to 16
            sub     rsp, 8

            ; ref: https://stackoverflow.com/a/41322328
            ; ref: https://www.nasm.us/xdoc/2.10rc8/html/nasmdoc9.html#section-9.2.5
            ; need a special PIC relocation type
            call    sprintf WRT ..plt

            add     rsp, 8              ; restore rsp

            ret                         ; return

            section .data
format:     db      "One for %s, one for me.", 0
youstr:     db      "you", 0
