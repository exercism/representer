(module
  (memory (export "mem") 1)

  (global $alphaOffset i32 (i32.const 512))
  (global $alphaLength i32 (i32.const  26))
  (data   $alphabet "abcdefghijklmnopqurstuvwxyz")

  (func  $initializeAlphabet
    (memory.init 
      $alphabet
      (global.get $alphaOffset)
      (i32.const 0)
      (global.get $alphaLength)
    )
  )
  (start $initializeAlphabet)

  ;; Detects whether a given character is lowercase ASCII
  (func $lowercase? (param $char i32) (result i32)
    (i32.and 
      (i32.ge_s (local.get $char) (i32.const  97))     ;; "a"
      (i32.le_s (local.get $char) (i32.const 122))))   ;; "z"

  ;; Detects whether a given character is uppercase ASCII
  (func $uppercase? (param $char i32) (result i32)
    (i32.and 
      (i32.ge_s (local.get $char) (i32.const 65))      ;; "A"
      (i32.le_s (local.get $char) (i32.const 90))))    ;; "Z"

  ;; Detects whether a given character is an ASCII letter
  (func $letter? (param $char i32) (result i32)
    (i32.or 
      (call $lowercase? (local.get $char))
      (call $uppercase? (local.get $char))))

  (func $mark_letter_used (param $char i32)
    ;; If the character isn't a letter, ignore it.
    (if (i32.eqz (call $letter? (local.get $char))) (return))

    ;; Convert the $char into an index
    (if (call $uppercase? (local.get $char))
    (then
      (local.set $char (i32.sub (local.get $char) (i32.const 65)))
    )
    (else 
      (local.set $char (i32.sub (local.get $char) (i32.const 97)))
    ))
      
    ;; Set the corresponding character in the memory region holding
    ;; the alphabet to zero.
    (i32.store8 
      (i32.add (global.get $alphaOffset) (local.get $char))
      (i32.const 0)
    )
  )

  (func $used_all_letters? (result i32)
    (local $i i32) (local $end i32)
    (local.set $i   (global.get $alphaOffset))
    (local.set $end (i32.add (global.get $alphaOffset) (global.get $alphaLength)))

    (block $loop (loop $next
      (br_if $loop (i32.ge_s (local.get $i) (local.get $end)))

      (i32.load8_s (local.get $i))
      (i32.const 0)
      i32.gt_s
      (if (then (return (i32.const 0))))

      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br $next)
    ))

    (i32.const 1)
  )

  ;; return 1 if pangram, 0 otherwise
  (func (export "isPangram") (param $offset i32) (param $length i32) (result i32)
    (local $end i32)
    (local.set $end (i32.add (local.get $offset) (local.get $length)))
    
    (block $loop (loop $next
      (br_if $loop (i32.ge_s (local.get $offset) (local.get $end)))

      (i32.load8_s (local.get $offset))
      (call $mark_letter_used)
      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))

      (br $next)
    ))
    
    (return (call $used_all_letters?))
  ) 
)
