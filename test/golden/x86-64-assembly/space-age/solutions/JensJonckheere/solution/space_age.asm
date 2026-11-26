section .text
global age
age:
        lea         rax, [rel orbit_array]              ; get the array address
        movss       xmm0, [rax + rdi*4]                 ; get the orbit in earth years
        movss       xmm1, [rel earth_orbit_in_seconds]  ; get earth orbit in seconds
        mulss       xmm1, xmm0                          ; get the orbit in seconds in xmm1
        cvtsi2ss    xmm0, rsi                           ; get the seconds in xmm0
        divss       xmm0, xmm1                          ; get the orbit in planet years
        ret

earth_orbit_in_seconds: dd 31557600.0

orbit_array:            dd 0.2408467, 0.61519726, 1.0, \
                           1.8808158, 11.862615, 29.447498, \
                           84.016846, 164.79132

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
