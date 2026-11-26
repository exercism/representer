(module
  ;;
  ;; count the number of 1 bits in the binary representation of a number
  ;;
  ;; @param {i32} number - the number to count the bits of
  ;;
  ;; @returns {i32} the number of 1 bits in the binary representation of the number
  ;;
  (func (export "eggCount") (param $number i32) (result i32)
    (local $ones i32)
    loop $LOOP
      (i32.ge_s (local.get $number) (i32.const 1))
      if
        (i32.rem_s (local.get $number) (i32.const 2))
        if
          (local.set $ones (i32.add (local.get $ones) (i32.const 1)))
        end
    
        (local.set $number
          (i32.div_s (local.get $number) (i32.const 2)))

        br $LOOP
      end
    end

    (return (local.get $ones))
  )
)