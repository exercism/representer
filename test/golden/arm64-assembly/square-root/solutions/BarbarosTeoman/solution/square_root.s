.text
.globl square_root

square_root:
        mov x1, x0        // x1 = n (input)
        mov x7, #0        // left = 0
        add x9, x0, #1    // right = n+1

binarySearch:
        add x10, x7, x9   // mid = (left+right) / 2
        lsr x10, x10, #1  

        mul x11, x10, x10 // mid²
        cmp x11, x1       
        ble mid_ok        // if mid² <= n
        mov x9, x10       // right = mid
        b check_done

mid_ok:
        mov x7, x10       // left = mid

check_done:
        sub x12, x9, x7   // if right-left > 1, continue
        cmp x12, #1
        bgt binarySearch

done:
        mov x0, x7        // return left
        ret
