(module
  (memory (export "mem") 1)

  ;;
  ;; Truncate UTF-8 input string to 5 characters
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the truncated string in linear memory
  ;;
  (func (export "truncate") (param $offset i32) (param $length i32) (result i32 i32)
    (local $char i32) (local $pos i32) (local $count i32)
    (loop $chars
      (local.set $char (i32.clz (i32.shl (i32.xor
        (i32.load8_u (i32.add (local.get $offset) (local.get $pos)))
        (i32.const 248)) (i32.const 24))))
      (local.set $count (i32.add (local.get $count) (i32.const 1)))
      (local.set $pos (i32.add (local.get $pos)
        (i32.add (i32.eqz (local.get $char)) (local.get $char))))
    (br_if $chars (i32.and (i32.lt_u (local.get $count) (i32.const 5))
      (i32.lt_u (local.get $pos) (local.get $length)))))
    (local.get $offset) (local.get $pos)
  )
)
