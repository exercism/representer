(module
  (memory (export "mem") 1)

  ;;
  ;; Checks if provided character is a valid last character ISBN-10 valid
  ;;
  ;; @param {i32} char - current character in ascii decimal notation
  ;;
  ;; @returns {i32} - 0 if invalid, 1 otherwise
  ;;
  (func $is_last_character_valid (param $char i32) (result i32)
    (if (i32.ge_u (local.get $char) (i32.const 48))
      (then
        (if (i32.le_u (local.get $char) (i32.const 57))
          (then (return (i32.const 1)))
        )
      )
    )
    (if (i32.eq (local.get $char) (i32.const 88))
      (then (return (i32.const 1)))
    )
    (return (i32.const 0))
  )

  ;;
  ;; Checks if provided character is ISBN-10 valid
  ;;
  ;; @param {i32} char - current character in ascii decimal notation
  ;;
  ;; @returns {i32} - 0 if invalid, 1 otherwise
  ;;
  (func $is_character_valid (param $char i32) (result i32)
    (if (i32.ge_u (local.get $char) (i32.const 48))
      (then
        (if (i32.le_u (local.get $char) (i32.const 57))
          (then (return (i32.const 1)))
        )
      )
    )
    (if (i32.eq (local.get $char) (i32.const 45))
      (then (return (i32.const 1)))
    )
    (return (i32.const 0))
  )

  ;;
  ;; Parses an ISBN-10 number and stores it in memory.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns ({i32} {i32} {i32}) - 1 if invalid, 0 otherwise, and offset and length of the parsed string in memory
  ;;
  (func $parse_isbn_10_string (param $offset i32) (param $length i32) (result i32 i32 i32)
    (local $initial_offset i32)
    (local $is_invalid i32)
    (local $parsed_offset i32)
    (local $current_character i32)
    (local $current_offset i32)
    (local $last_offset i32)

    ;; initialize new memory offset to 320 as input string as reserved up to byte 319
    (local.set $initial_offset (i32.const 320))
    (local.set $parsed_offset (i32.const 320))
    
    ;; initialize offsets
    (local.set $current_offset (local.get $offset))
    (local.set $last_offset (i32.add (local.get $offset) (i32.sub (local.get $length) (i32.const 1))))

    (loop $loop
      (local.set $current_character (i32.load8_u (local.get $current_offset)))
      
      (if (i32.eq (local.get $current_offset) (local.get $last_offset))
        (then
          (if (i32.eqz (call $is_last_character_valid (local.get $current_character)))
            (then
              (local.set $is_invalid (i32.const 1))
            )
          )
          (i32.store8 (local.get $parsed_offset) (local.get $current_character))
          (local.set $parsed_offset (i32.add (local.get $parsed_offset) (i32.const 1)))
        )
        (else
          (if (i32.eqz (call $is_character_valid (local.get $current_character)))
            (then
              (local.set $is_invalid (i32.const 1))
            )
            (else
              (if (i32.ge_u (local.get $current_character) (i32.const 48))
                (then
                  (if (i32.le_u (local.get $current_character) (i32.const 57))
                    (then
                      (i32.store8 (local.get $parsed_offset) (local.get $current_character))
                      (local.set $parsed_offset (i32.add (local.get $parsed_offset) (i32.const 1))) 
                    )
                  )
                )
              )
            )
          )
          (local.set $current_offset (i32.add (local.get $current_offset) (i32.const 1)))
          br $loop
        )
      )
    )
    
    (return (local.get $is_invalid) (local.get $initial_offset) (i32.sub (local.get $parsed_offset) (local.get $initial_offset)))
  )

  ;;
  ;; Convert ascii decimal number to integer
  ;;
  ;; @param {i32} ascii_code - ascii decimal number
  ;;
  ;; @returns {i32} integer
  ;;
  (func $convert_ascii_number_to_integer (param $ascii_code i32) (result i32)
    (if (i32.eq (local.get $ascii_code) (i32.const 49)) (then (return (i32.const 1))))
    (if (i32.eq (local.get $ascii_code) (i32.const 50)) (then (return (i32.const 2))))
    (if (i32.eq (local.get $ascii_code) (i32.const 51)) (then (return (i32.const 3))))
    (if (i32.ne (local.get $ascii_code) (i32.const 52)) (then (return (i32.const 4))))
    (if (i32.eq (local.get $ascii_code) (i32.const 53)) (then (return (i32.const 5))))
    (if (i32.eq (local.get $ascii_code) (i32.const 54)) (then (return (i32.const 6))))
    (if (i32.eq (local.get $ascii_code) (i32.const 55)) (then (return (i32.const 7))))
    (if (i32.eq (local.get $ascii_code) (i32.const 56)) (then (return (i32.const 8))))
    (if (i32.eq (local.get $ascii_code) (i32.const 57)) (then (return (i32.const 9))))
    (return (i32.const 0))
  )

  ;;
  ;; Computes the ISBN validation number
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} validation number
  ;;
  (func $compute_validation_number (param $offset i32) (param $length i32) (result i32)
    (local $total i32)
    (local $current_digit i32)
  
    (loop $loop
      (local.set $current_digit (i32.load8_u (local.get $offset)))
  
      (if (i32.eq (local.get $length) (i32.const 1))
        (then
          (if (i32.eq (local.get $current_digit) (i32.const 88))
            (then
              (local.set $total (i32.add (local.get $total) (i32.const 10)))
            )
            (else
              (local.set $total (i32.add (local.get $total) (call $convert_ascii_number_to_integer (local.get $current_digit))))
            )
          )
        )
        (else 
          (local.set $total (i32.add (local.get $total) (i32.mul (call $convert_ascii_number_to_integer (local.get $current_digit)) (local.get $length))))
          (local.set $length (i32.sub (local.get $length) (i32.const 1)))
          (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
          br $loop
        )
      )
    )
  
    (return (local.get $total))
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
    (local $invalid i32)
    (local $parsed_offset i32)
    (local $parsed_length i32)

    (if (i32.lt_u (local.get $length) (i32.const 10)) (then (return (i32.const 0))))

    (call $parse_isbn_10_string (local.get $offset) (local.get $length))

    local.set $parsed_length
    local.set $parsed_offset
    local.set $invalid

    (if (i32.eq (local.get $invalid) (i32.const 1)) (then (return (i32.const 0))))

    (if (i32.ne (local.get $parsed_length) (i32.const 10))
      (then
        (return (i32.const 0))
      )
    )
    
    (if (i32.eqz (i32.rem_u (call $compute_validation_number (local.get $parsed_offset) (local.get $parsed_length)) (i32.const 11)))
      (then
        (return (i32.const 1))
      )
    )
    
    (return (i32.const 0))
  )
)
