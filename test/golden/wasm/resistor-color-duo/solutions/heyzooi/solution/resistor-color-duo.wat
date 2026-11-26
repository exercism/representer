(module
  (memory (export "mem") 1)
  ;;
  ;; Given a valid resistor color, returns the associated value
  ;;
  ;; @param {i32} offset - offset into the color buffer
  ;; @param {i32} len - length of the color string
  ;;
  ;; @returns {i32} - the associated value
  ;;
  (func $colorCode (param $offset i32) (param $len i32) (result i32)
    (local $c i32)
    (local.set $c (i32.load8_u (local.get $offset)))
    (if (i32.eq (local.get $c) (i32.const 98 (;b;)))
      (then 
        (local.set $c (i32.load8_u (i32.add (local.get $offset) (i32.const 1))))
        (if (i32.eq (local.get $c) (i32.const 108 (;l;)))
          (then
            (local.set $c (i32.load8_u (i32.add (local.get $offset) (i32.const 2))))
            (if (i32.eq (local.get $c) (i32.const 97 (;a;)))
              (then
                (return (i32.const 0))
              )
            )
            (if (i32.eq (local.get $c) (i32.const 117 (;u;)))
              (then
                (return (i32.const 6))
              )
            )
          )
        )
        (if (i32.eq (local.get $c) (i32.const 114 (;r;)))
          (then
            (return (i32.const 1))
          )
        )
      )
    )
    (if (i32.eq (local.get $c) (i32.const 114 (;r;)))
      (then
        (return (i32.const 2))
      )
    )
    (if (i32.eq (local.get $c) (i32.const 111 (;o;)))
      (then
        (return (i32.const 3))
      )
    )
    (if (i32.eq (local.get $c) (i32.const 121 (;y;)))
      (then
        (return (i32.const 4))
      )
    )
    (if (i32.eq (local.get $c) (i32.const 103 (;g;)))
      (then
        (local.set $c (i32.load8_u (i32.add (local.get $offset) (i32.const 3))))
        (if (i32.eq (local.get $c) (i32.const 101 (;e;)))
          (then
            (return (i32.const 5))
          )
        )
        (if (i32.eq (local.get $c) (i32.const 121 (;y;)))
          (then
            (return (i32.const 8))
          )
        )
      )
    )
    (if (i32.eq (local.get $c) (i32.const 118 (;v;)))
      (then
        (return (i32.const 7))
      )
    )
    (if (i32.eq (local.get $c) (i32.const 119 (;w;)))
      (then
        (return (i32.const 9))
      )
    )
    (return (i32.const -1))
  )

  ;;
  ;; Converts color codes, as used on resistors, to a numeric value.
  ;;
  ;; @param {i32} firstOffset - The offset of the first string in linear memory.
  ;; @param {i32} firstLength - The length of the first string in linear memory.
  ;; @param {i32} secondOffset - The offset of the second string in linear memory.
  ;; @param {i32} secondLength - The length of the second string in linear memory.
  ;;
  ;; @returns {i32} - The numeric value specified by the color codes.
  ;;
  (func (export "value")
    (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32) (result i32)
    (local $first i32)
    (local $second i32)
    (local.set $first
      (i32.mul
        (call $colorCode (local.get $firstOffset) (local.get $firstLength))
        (i32.const 10)
      )
    )
    (local.set $second
      (call $colorCode (local.get $secondOffset) (local.get $secondLength))
    )
    (i32.add (local.get $first) (local.get $second))
  )
)
