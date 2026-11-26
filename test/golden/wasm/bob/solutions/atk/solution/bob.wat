(module
  (memory (export "mem") 1)
  (data (i32.const 320) "Sure.Whoa, chill out!Calm down, I know what I'm doing!Fine. Be that way!Whatever.")

  ;;
  ;; Reply to someone when they say something or ask a question
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the reversed string in linear memory
  ;;
  (func (export "response") (param $offset i32) (param $length i32) (result i32 i32)
    ;; 1 - non-space, 2 - upper case, 4 - lower case, 8 - query at the end
    (local $char i32) (local $attr i32) (local.set $attr (i32.const 0))
    (if (i32.ne (local.get $length) (i32.const 0)) (then
    (loop $chars
      (local.set $length (i32.sub (local.get $length) (i32.const 1)))
      (local.set $char (i32.load8_u (i32.add (local.get $offset) (local.get $length))))
      (if (i32.and (i32.eq (local.get $char) (i32.const 63))
        (i32.eq (local.get $attr) (i32.const 0))) ;; query at the end
          (then (local.set $attr (i32.or (local.get $attr) (i32.const 8)))))
      (if (i32.and (i32.ge_u (local.get $char) (i32.const 97)) 
        (i32.le_u (local.get $char) (i32.const 122))) ;; lower case
          (then (local.set $attr (i32.or (local.get $attr) (i32.const 4)))))
      (if (i32.and (i32.ge_u (local.get $char) (i32.const 65)) 
        (i32.le_u (local.get $char) (i32.const 90))) ;; upper case
          (then (local.set $attr (i32.or (local.get $attr) (i32.const 2)))))
      (if (i32.ge_u (local.get $char) (i32.const 33)) ;; non-space chars
        (then (local.set $attr (i32.or (local.get $attr) (i32.const 1)))))
      (br_if $chars (local.get $length))
    )))
    (if (i32.eq (local.get $attr) (i32.const 11))
      (then (return (i32.const 341) (i32.const 33)))) ;; "Calm down, I know what I'm doing!"
    (if (i32.ge_u (local.get $attr) (i32.const 9))
      (then (return (i32.const 320) (i32.const 5)))) ;; "Sure."
    (if (i32.eq (local.get $attr) (i32.const 3))
      (then (return (i32.const 325) (i32.const 16)))) ;; "Whoa, chill out!"
    (if (i32.ge_u (local.get $attr) (i32.const 1))
      (then (return (i32.const 392) (i32.const 9)))) ;; "Whatever."
    (return (i32.const 374) (i32.const 18)) ;; "Fine. Be that way!"
  )
)
