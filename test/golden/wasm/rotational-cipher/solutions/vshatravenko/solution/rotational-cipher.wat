(module
  (memory (export "mem") 1)

  (global $A i32 (i32.const 65))
  (global $Z i32 (i32.const 90))
  (global $a i32 (i32.const 97))
  (global $z i32 (i32.const 122))
  (global $totalLetters i32 (i32.const 26))

  (func (export "rotate") (param $textOffset i32) (param $textLength i32) (param $shiftKey i32) (result i32 i32)
    (local $i i32)
    (local $c i32)
    (local $curOffset i32)

    (loop $main
      (local.set $c
        (i32.load8_u (i32.add (local.get $textOffset) (local.get $i)))
      )

      (if
        (i32.and (i32.ge_u (local.get $c) (global.get $A)) (i32.le_u (local.get $c) (global.get $Z)))
        (then
          (local.set $c (call $convert (local.get $c) (local.get $shiftKey) (global.get $Z)))
        )
      )

      (if
        (i32.and (i32.ge_u (local.get $c) (global.get $a)) (i32.le_u (local.get $c) (global.get $z)))
        (then
          (local.set $c (call $convert (local.get $c) (local.get $shiftKey) (global.get $z)))
        )
      )

      (i32.store8 (i32.add (local.get $textOffset) (local.get $i)) (local.get $c))

      (br_if $main
        (i32.lt_s
          (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (local.get $textLength)
        )
      )
    )

    (return (local.get $textOffset) (local.get $textLength))
  )

  (func $convert (param $char i32) (param $shiftKey i32) (param $lastChar i32) (result i32)
    (local $result i32)

    (local.set $result (i32.add (local.get $char) (local.get $shiftKey)))

    (if (i32.gt_s (local.get $result) (local.get $lastChar))
      (then
        (local.set $result
          (i32.sub (local.get $result) (global.get $totalLetters))
        )
      )
    )

    (return (local.get $result))
  )
)
