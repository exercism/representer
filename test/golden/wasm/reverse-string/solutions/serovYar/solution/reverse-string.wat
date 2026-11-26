(module
  (memory (export "mem") 1)
 
  ;;
  ;; Reverse a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the reversed string in linear memory
  ;;
   (func (export "reverseString") (param $offset i32) (param $length i32) (result i32 i32)
    ;; Call "$reverse" function
    (call $reverse (local.get $offset)(local.get $offset)(local.get $length))
    (return (local.get $offset) (local.get $length))
  )

  (func $reverse (param $offset i32)(param $pointer i32) (param $remaining i32)
    (local $byte i32) (local.set $byte (i32.load8_s(local.get $pointer)))

    ;; If Then
    (if (i32.le_u(local.get $remaining)(i32.const 1))
      (then (i32.store8(local.get $offset)(local.get $byte)))

      ;; Else
      (else 
        (call $reverse 
          (local.get $offset)
          (i32.add(local.get $pointer)(i32.const 1))
          (i32.sub(local.get $remaining)(i32.const 1)))
        (i32.store8(i32.add(local.get $offset)(i32.sub(local.get $remaining)(i32.const 1)))(local.get $byte))
      )
    )
  )
)
