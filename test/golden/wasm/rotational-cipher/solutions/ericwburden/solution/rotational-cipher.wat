(module
  (memory (export "mem") 1)

  (global $a           i32 (i32.const 97))
  (global $z           i32 (i32.const 122))
  (global $A           i32 (i32.const 65))
  (global $Z           i32 (i32.const 90))
  (global $letterCount i32 (i32.const 26))

  ;; Detects whether a given character is lowercase ASCII
  (func $lowercase? (param $char i32) (result i32)
    (i32.and 
      (i32.ge_s (local.get $char) (global.get $a))
      (i32.le_s (local.get $char) (global.get $z))))

  ;; Detects whether a given character is uppercase ASCII
  (func $uppercase? (param $char i32) (result i32)
    (i32.and 
      (i32.ge_s (local.get $char) (global.get $A))
      (i32.le_s (local.get $char) (global.get $Z))))

  ;; Detects whether a given character is an ASCII letter
  (func $letter? (param $char i32) (result i32)
    (i32.or 
      (call $lowercase? (local.get $char))
      (call $uppercase? (local.get $char))))
  
  ;; Rotate a single character by $amount
  (func $rotateChar (param $char i32) (param $amount i32) (result i32)
    (local $offset i32)
    (local.set $offset 
      (if (result i32) (call $lowercase? (local.get $char)) 
        (then (global.get $a))
        (else (global.get $A))))

    ;; 0-index the ASCII character code, increase the value by $amount,
    ;; wrap it around if necessary, then offset it back into the appropriate
    ;; range.
    (local.get $char)
    (local.get $amount)
    (i32.add)              ;; Add the shift amount to the character
    (local.get $offset)
    (i32.sub)              ;; Subtract the offset from 'a' or 'A'
    (global.get $letterCount)
    (i32.rem_s)            ;; Wrap around the alphabet
    (local.get $offset)
    (i32.add)              ;; Add the offset back
  )

  ;; Rotate an entire string, character-by-character, by $shiftKey amount.
  (func (export "rotate") (param $textOffset i32) (param $textLength i32) (param $shiftKey i32) (result i32 i32)
    (local $char i32)
    (local $index i32)
    (local.set $index (i32.const 0))

    ;; If the $shiftKey is zero, return the original string.
    (if (i32.eqz (local.get $shiftKey))
      (return (local.get $textOffset) (local.get $textLength)))
    
    ;; For each character, if it's a letter, rotate it by $shiftKey amount. If
    ;; it's any other kind of character, skip it.
    (loop
      (local.set $char (i32.load8_s (i32.add (local.get $textOffset) (local.get $index))))
      (if (call $letter? (local.get $char)) (then
        (local.set $char (call $rotateChar (local.get $char) (local.get $shiftKey)))
        (i32.store8 (i32.add (local.get $textOffset) (local.get $index)) (local.get $char))
      ))
      (local.set $index (i32.add (local.get $index) (i32.const 1)))
      (br_if 0 (i32.lt_s (local.get $index) (local.get $textLength)))
    )  
    
    (return (local.get $textOffset) (local.get $textLength))
  )
)
