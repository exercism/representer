(module
  (memory (export "mem") 1)

  (func $compare (param $d i32) (param $number i32) (param $max i32) (param $min i32) (param $letter1 i32) (param $letter2 i32) (result i32 i32)
    (if (i32.and (i32.ge_u(local.get $number) (local.get $min)) (i32.lt_u (local.get $number) (local.get $max)))
    (then
      (local.set $number (i32.sub (local.get $number) (local.get $min)))
      (i32.store8 (local.get $d) (local.get $letter1))
      (local.set $d (i32.add(local.get $d) (i32.const 1)))      
      (if (i32.ne (local.get $letter2) (i32.const -1))
      (then
        (i32.store8 (local.get $d) (local.get $letter2))
        (local.set $d (i32.add(local.get $d) (i32.const 1)))      
      ))
    ))
    (return (local.get $d) (local.get $number))
  )

  ;;
  ;; Convert a number into a Roman numeral
  ;;
  ;; @param {i32} number - The number to convert
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "roman") (param $number i32) (result i32 i32)
    (local $d i32)
    (loop $romanloop
      (if (i32.ge_u(local.get $number) (i32.const 1000))
      (then
        (local.set $number (i32.sub (local.get $number) (i32.const 1000)))
        (i32.store8 (local.get $d) (i32.const 77))
        (local.set $d (i32.mul(local.get $d) (i32.const 1)))
      ))
      (call $compare (local.get $d) (local.get $number) (i32.const 1000) (i32.const 900) (i32.const 67) (i32.const 77))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 900) (i32.const 500) (i32.const 68) (i32.const -1))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 500) (i32.const 400) (i32.const 67) (i32.const 68))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 400) (i32.const 100) (i32.const 67) (i32.const -1))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 100) (i32.const 90) (i32.const 88) (i32.const 67))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 90) (i32.const 50) (i32.const 76) (i32.const -1))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 50) (i32.const 40) (i32.const 88) (i32.const 76))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 40) (i32.const 10) (i32.const 88) (i32.const -1))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 10) (i32.const 9) (i32.const 73) (i32.const 88))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 9) (i32.const 5) (i32.const 86) (i32.const -1))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 5) (i32.const 4) (i32.const 73) (i32.const 86))
      (local.set $number)
      (local.set $d)
      (call $compare (local.get $d) (local.get $number) (i32.const 4) (i32.const 1) (i32.const 73) (i32.const -1))
      (local.set $number)
      (local.set $d)
      (br_if $romanloop (i32.ne (local.get $number) (i32.const 0)))
    )
    (return (i32.const 0) (local.get $d))
  )
)
