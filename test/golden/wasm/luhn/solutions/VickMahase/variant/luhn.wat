(module
  (memory (export "mem") 1)

  ;;
  ;; Checks if a string is valid per the Luhn formula.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if valid per Luhn formula, 0 otherwise
  ;;
  (func (export "valid") (param $offset i32) (param $length i32) (result i32)
    (local $i i32)              ;; Loop counter
    (local $digit_count i32)    ;; Count of digits (excluding spaces)
    (local $sum i32)            ;; Sum of all processed digits
    (local $char i32)           ;; Current character
    (local $digit i32)          ;; Current digit value
    (local $position i32)       ;; Position from right (for determining which digits to double)
    (local $digit_array i32)    ;; Starting address for digit array
    
    ;; Set digit array to start at offset 320 (after input buffer)
    (local.set $digit_array (i32.const 320))
    
    ;; Initialize digit count
    (local.set $digit_count (i32.const 0))
    
    ;; First pass: Remove spaces and check for invalid characters
    (local.set $i (i32.const 0))
    (block $count_done
      (loop $count_loop
        ;; Break if we've reached the end of the string
        (br_if $count_done (i32.ge_u (local.get $i) (local.get $length)))
        
        ;; Get current character
        (local.set $char (i32.load8_u (i32.add (local.get $offset) (local.get $i))))
        
        ;; If it's a space, skip it
        (if (i32.eq (local.get $char) (i32.const 32))
          (then
            (local.set $i (i32.add (local.get $i) (i32.const 1)))
            (br $count_loop)
          )
        )
        
        ;; Check if it's a digit
        (if (i32.and
              (i32.ge_u (local.get $char) (i32.const 48))  ;; '0'
              (i32.le_u (local.get $char) (i32.const 57))  ;; '9'
            )
          (then
            ;; Store digit in our array and increment count
            (i32.store8
              (i32.mul (local.get $digit_array) (local.get $digit_count))
              (i32.sub (local.get $char) (i32.const 48))  ;; Convert ASCII to number
            )
            (local.set $digit_count (i32.add (local.get $digit_count) (i32.const 1)))
          )
          (else
            ;; Invalid character
            (return (i32.const 0))
          )
        )
        
        ;; Move to next character
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $count_loop)
      )
    )
    
    ;; Check if we have at least 2 digits
    (if (i32.lt_s (local.get $digit_count) (i32.const 2))
      (then
        (return (i32.const 0))
      )
    )
    
    ;; Apply Luhn algorithm
    (local.set $sum (i32.const 0))
    
    ;; Process digits from right to left
    (local.set $i (i32.sub (local.get $digit_count) (i32.const 1)))
    (local.set $position (i32.const 0))  ;; Start with position 0 (rightmost digit)
    
    (block $process_done
      (loop $process_loop
        ;; Break if we've processed all digits
        (br_if $process_done (i32.lt_s (local.get $i) (i32.const 0)))
        
        ;; Get current digit
        (local.set $digit 
          (i32.load8_u (i32.add (local.get $digit_array) (local.get $i)))
        )
        
        ;; Double every second digit (position 1, 3, 5, etc. from right)
        (if (i32.eq (i32.rem_u (local.get $position) (i32.const 2)) (i32.const 1))
          (then
            (local.set $digit (i32.mul (local.get $digit) (i32.const 2)))
            ;; If doubled result > 9, subtract 9
            (if (i32.gt_u (local.get $digit) (i32.const 9))
              (then
                (local.set $digit (i32.sub (local.get $digit) (i32.const 9)))
              )
            )
          )
        )
        
        ;; Add to sum
        (local.set $sum (i32.add (local.get $sum) (local.get $digit)))
        
        ;; Move to next digit and increment position
        (local.set $i (i32.sub (local.get $i) (i32.const 1)))
        (local.set $position (i32.add (local.get $position) (i32.const 1)))
        (br $process_loop)
      )
    )
    
    ;; Check if sum is divisible by 10
    (i32.eq (i32.rem_u (local.get $sum) (i32.const 10)) (i32.const 0))
  )
)