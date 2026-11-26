.equ INVALID_NUMBER, -1

.text

// int64_t steps(int64_t x)

#ifdef __APPLE__

.globl _steps
_steps:

#else

.globl steps
steps:

#endif

    mov x1, x0   // x1 = x
    mov x0, xzr  // int64_t n = 0;

    cmp x1, 0    // if (x > 0) goto .while;
    bgt .while

    // return -1;
    mov x0, INVALID_NUMBER
    ret

.inc:
    add x0, x0, 1          // n++;

    tbz x1, 0, .even       // if ((x & 1) == 0) goto .even;

    add x1, x1, x1, lsl 1  // x *= 3
    add x1, x1, 1          // x += 1

    // 3x+1 is always even,
    // so we count another step and fall through
    add x0, x0, 1          // n++;
.even:
    asr x1, x1, 1          // x /= 2
.while:  // while (x != 1)
    cmp x1, 1
    bne .inc
    ret  // return n;
