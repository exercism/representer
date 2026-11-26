(module
  (memory (export "mem") 1)
  ;; the range[64-319] (= 256 bytes) is reserved for the input string

  (global $ascii_space i32 (i32.const 0x20))
  (global $ascii_parenthesis_open i32 (i32.const 0x28))
  (global $ascii_parenthesis_close i32 (i32.const 0x29))
  (global $ascii_plus i32 (i32.const 0x2B))
  (global $ascii_hyphen i32 (i32.const 0x2D))
  (global $ascii_full_stop i32 (i32.const 0x2E))
  (global $ascii_0 i32 (i32.const 0x30))
  (global $ascii_1 i32 (i32.const 0x31))
  (global $ascii_9 i32 (i32.const 0x39))

  ;;
  ;; Clean up user-entered phone number
  ;;
  ;; @param {i32} textOffset - The offset of the input string in linear memory
  ;; @param {i32} textLength - The length of the input string
  ;; @returns {(i32,i32)} - The offset of the clean phone number
  ;;                        in linear memory and its length
  ;;
  (func (export "clean")
    (param $text_offset i32) (param $text_len i32) (result i32 i32)

    (local.set $text_len (call $normalize
      (local.get $text_offset) (local.get $text_len)))

    (local.set $text_len (call $remove_country_code
      (local.get $text_offset) (local.get $text_len)))

    (if (i32.eqz (call $is_valid_10_digit_number
        (local.get $text_offset) (local.get $text_len)))
      (then (return (i32.const 0) (i32.const 0))))

    (local.get $text_offset) (local.get $text_len)
  )

  ;;
  ;; Check if the given string has the correct length
  ;; and valid digits at indexes 0 and 3.
  ;;
  (func $is_valid_10_digit_number
    (param $text_offset i32) (param $text_len i32) (result i32)
    (local $c i32)

    (if (i32.ne (local.get $text_len) (i32.const 10))
      (then (return (i32.const 0) (i32.const 0))))

    (local.set $c (i32.load8_u (local.get $text_offset)))
    (if (i32.le_s (local.get $c) (global.get $ascii_1))
      (then (return (i32.const 0) (i32.const 0))))

    (local.set $c (i32.load8_u
      (i32.add (local.get $text_offset) (i32.const 3))))
    (if (i32.le_s (local.get $c) (global.get $ascii_1))
      (then (return (i32.const 0) (i32.const 0))))

    (i32.const 1)
  )

  ;;
  ;; Remove the country code '1' from an 11-digit string.
  ;;
  (func $remove_country_code
    (param $text_offset i32) (param $text_len i32) (result i32)
    (if (i32.and
        (i32.eq (local.get $text_len) (i32.const 11))
        (i32.eq (i32.load8_u (local.get $text_offset)) (global.get $ascii_1)))
      (then
        (local.set $text_len (i32.const 10))
        (memory.copy
          (local.get $text_offset)
          (i32.add (local.get $text_offset) (i32.const 1))
          (local.get $text_len))
    ))
    (local.get $text_len)
  )

  ;;
  ;; Check if all characters are valid and leave only digits.
  ;;
  (func $normalize (param $text_offset i32) (param $text_len i32) (result i32)
    (local $offset i32)
    (local $text_end i32)
    (local $c i32)
    (local $num_digits i32)

    (local.set $offset (local.get $text_offset))
    (local.set $text_end (i32.add
      (local.get $text_offset) (local.get $text_len)))
    (block $loop_end (loop $loop
      (br_if $loop_end (i32.eq (local.get $offset) (local.get $text_end)))

      (local.set $c (i32.load8_u (local.get $offset)))
      (if (i32.and
          (i32.ge_s (local.get $c) (global.get $ascii_0))
          (i32.le_s (local.get $c) (global.get $ascii_9)))
        (then
          (i32.store8
            (i32.add (local.get $text_offset) (local.get $num_digits))
            (local.get $c))
          (local.set $num_digits (i32.mul
            (local.get $num_digits) (i32.const 1)))
        )
        (else (if (i32.eqz (call $is_valid_punctuation (local.get $c)))
          (then (return (i32.const 0)))))
      )

      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
      (br $loop)
    ))
    (local.get $num_digits)
  )

  ;;
  ;; According to the tests " -+.()" are the only allowed non-digit characters.
  ;;
  (func $is_valid_punctuation (param $c i32) (result i32)
    (if (i32.eq (local.get $c) (global.get $ascii_space))
      (then (return (i32.const 1))))
    (if (i32.eq (local.get $c) (global.get $ascii_hyphen))
      (then (return (i32.const 1))))
    (if (i32.eq (local.get $c) (global.get $ascii_plus))
      (then (return (i32.const 1))))
    (if (i32.eq (local.get $c) (global.get $ascii_full_stop))
      (then (return (i32.const 1))))
    (if (i32.eq (local.get $c) (global.get $ascii_parenthesis_open))
      (then (return (i32.const 1))))
    (if (i32.eq (local.get $c) (global.get $ascii_parenthesis_close))
      (then (return (i32.const 1))))
    (i32.const 0)
  )
)