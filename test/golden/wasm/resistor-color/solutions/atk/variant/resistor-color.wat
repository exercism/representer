(module
  (memory (export "mem") 1)
  (data (i32.const 0) "\6b\62\6e\62\64\72\65\6f\77\79\6e\67\65\62\74\76\79\67\65\77")
  (data (i32.const 21) "black,brown,red,orange,yellow,green,blue,violet,grey,white")

  ;;
  ;; Return buffer of comma separated colors
  ;; "black,brown,red,orange,yellow,green,blue,violet,grey,white"
  ;;
  ;; @returns {(i32, i32)} - The offset and length of the buffer of comma separated colors
  ;;
  (func (export "colors") (result i32 i32)
    (return (i32.const 21) (i32.const 58))
  )

  ;;
  ;; Converts a single color code, as used on resistors, to a numeric value.
  ;;
  ;; @param {i32} offset - start of the color string.
  ;; @param {i32} length - length of the color string.
  ;;
  ;; @returns {i32} - the numeric value of the color code.
  ;;
  (func (export "colorCode") (param $offset i32) (param $length i32) (result i32)
    (local $chars i32) (local $num i32)
    (local.set $chars (i32.or (i32.shl (i32.load8_u (local.get $offset)) (i32.const 8))
      (i32.load8_u (i32.add (local.get $offset) (i32.add (local.get $length) (i32.const 1))))))
    (loop $numbers
      (if (i32.eq (local.get $chars) (i32.load16_u (i32.shl (local.get $num) (i32.const 1))))
        (then (return (local.get $num))))
      (local.set $num (i32.add (local.get $num) (i32.const 1)))
    (br_if $numbers (i32.le_u (local.get $num) (i32.const 10))))
    (return (i32.const -1))
  )
)
