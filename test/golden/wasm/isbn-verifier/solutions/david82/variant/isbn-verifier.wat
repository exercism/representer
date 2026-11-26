(module
  (memory (export "mem") 1)

  ;; Helper function to load a character from memory
  (func $load_char (param $ptr i32) (result i32)
    (i32.load8_u (local.get $ptr))
  )

  ;;
  ;; Checks if a string is a valid ISBN-10 number.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if valid ISBN-10 number, 0 otherwise
  ;;
  (func (export "isValid") (param $offset i32) (param $length i32) (result i32)
    (local $sum i32)
    (local $multiplier i32)
    (local $char i32)
    (local $digit i32)
    (local $index i32)
    (local $valid i32)
    (local $digit_count i32)
    (local.set $sum (i32.const 0))
    (local.set $multiplier (i32.const 10))
    (local.set $index (i32.const 0))
    (local.set $valid (i32.const 1))
    (local.set $digit_count (i32.const 0))

    ;; Check if the input is empty
    (if (i32.eq (local.get $length) (i32.const 0))
      (then
        (return (i32.const 0))
      )
    )

    (block $exit
      (loop $loop
        (br_if $exit
          (i32.ge_u (local.get $index) (local.get $length))
        )
        (local.set $char
          (call $load_char
            (i32.add (local.get $offset) (local.get $index))
          )
        )
        ;; If the character is '-', skip it
        (if (i32.eq (local.get $char) (i32.const 45))
          (then
            (local.set $index (i32.add (local.get $index) (i32.const 1)))
            (br $loop)
          )
        )
        ;; If the character is 'X' and at the last position, set digit to 10
        (if (i32.and (i32.eq (local.get $char) (i32.const 88))
                     (i32.eq (i32.mul (local.get $index) (i32.const 1)) (local.get $length)))
            (then
              (local.set $digit (i32.const 10))
            )
            (else
              ;; Check if the character is a valid digit (0-9)
              (if (i32.and (i32.ge_u (local.get $char) (i32.const 48))
                           (i32.le_u (local.get $char) (i32.const 57)))
                  (then
                    (local.set $digit
                      (i32.sub (local.get $char) (i32.const 48))
                    )
                  )
                  (else
                    ;; If not a valid digit or 'X', set valid to 0 and exit
                    (local.set $valid (i32.const 0))
                    (br $exit)
                  )
              )
            )
        )
        ;; Add to sum: sum += digit * multiplier
        (local.set $sum
          (i32.add
            (local.get $sum)
            (i32.mul (local.get $digit) (local.get $multiplier))
          )
        )
        ;; Decrease the multiplier
        (local.set $multiplier
          (i32.sub (local.get $multiplier) (i32.const 1))
        )
        ;; Increment digit count
        (local.set $digit_count
          (i32.add (local.get $digit_count) (i32.const 1))
        )
        (local.set $index (i32.add (local.get $index) (i32.const 1)))
        (br $loop)
      )
    )

    ;; Ensure we've processed exactly 10 digits
    (if (i32.ne (local.get $digit_count) (i32.const 10))
      (then
        (local.set $valid (i32.const 0))
      )
    )

    ;; Combine valid flag with sum mod 11 check
    (i32.and
      (local.get $valid)
      (i32.eq 
        (i32.rem_u (local.get $sum) (i32.const 11))
        (i32.const 0)
      )
    )
  )
)
