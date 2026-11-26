(module
 ;;
 ;; count the number of 1 bits in the binary representation of a number
 ;;
 ;; @param {i32} number - the number to count the bits of
 ;;
 ;; @returns {i32} the number of 1 bits in the binary representation of the number
 ;;
 (func (export "eggCount") (param $number i32) (result i32)
       (local $count i32)
       (loop $loop
             (block $done
               ;; if $number == 0 then done
               (i32.eqz (local.get $number))
               (br_if $done)
               ;; $count++
               (local.set $count
                          (i32.add
                           (i32.const 1)
                           (local.get $count)))
               ;; number -= number & -number
               (local.set $number
                          (i32.sub
                           (local.get $number)
                           (i32.and
                            (local.get $number)
                            (i32.sub
                             (i32.const 0)
                             (local.get $number)))))
               ;; loop
               (br $loop)))
       (local.get $count)))
