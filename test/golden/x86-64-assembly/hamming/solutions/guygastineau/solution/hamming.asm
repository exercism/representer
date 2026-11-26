section .text
global distance

%define StrandA rdi
%define StrandB rsi

        ;; Offset the location of `distance' to align
        ;; `distance.loop' for practically no cost except code size.
        align 16
        times -(distance.loop - distance) % 16 nop

distance:
	;; Null pointer Guard.
        test StrandA, StrandB
        jz .fail

        ;; Build return value in EAX
        xor eax, eax

        .loop:
        ;;  Load our characters into registers.
        mov dl, byte [StrandA]
        mov cl, byte [StrandB]

        ;; Don't forget to increment the pointers.
        inc StrandA
        inc StrandB

        ;; Test equality.
        cmp dl, cl
        ;; Continue when equal.
        je .equal
        ;; Else inc distance
        inc eax
        ;; Check for unequal strings.
        ;; One is '\0' and the other is not (we checked above)
        test cl, dl
        ;; Continue
        jnz .loop

        .fail:
        mov eax, -1
        ret

        ;; Padding after the return in `distance.fail' requires no execution.
        .alignEqual:
        align 16

        .equal:
        ;; Test for end of sequences (ie. both are '\0').
        test dl, cl
        jnz .loop
        ;; Else exit successfully!
        ret
