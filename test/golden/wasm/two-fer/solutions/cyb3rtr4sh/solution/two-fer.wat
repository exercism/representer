(module
  (memory (export "mem") 1)
  (data (i32.const 0) "One for you, one for me.")
  (data (i32.const 24) "One for ")

  ;;
  ;; Given a string X, return a string that says "One for X, one for me."
  ;; If the X is empty, return the string "One for you, one for me."
  ;;
  ;; @param {i32} $offset - The offset of the name in linear memory.
  ;; @param {i32} $length - The length of the name in linear memory.
  ;; 
  ;; @return {(i32,i32)} - The offset and length the resulting string in linear memory.
  ;;
  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    (if(i32.eqz (local.get $length))
      (then (return (i32.const 0) (i32.const 24))))
    
    (i64.store 
      (i32.sub (local.get $offset) (i32.const 8)) 
      (i64.const 0x20726f6620656e4f)) ;; "One for "

    (v128.store 
      (i32.add (local.get $offset) (local.get $length)) 
      (v128.const i64x2 0x6f6620656e6f202c 0x2e656d2072)) ;; ", one for me."
      
    (return (i32.sub (local.get $offset) (i32.const 8)) (i32.add (local.get $length) (i32.const 21)))
  )
)
