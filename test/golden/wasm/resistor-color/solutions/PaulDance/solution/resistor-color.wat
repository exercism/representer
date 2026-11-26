(module
  (memory (export "mem") 1)
  (data
    (i32.const 200)
    "black,brown,red,orange,yellow,green,blue,violet,grey,white"
  )

  ;; Returns the buffer of comma-separated colors.
  (func $colors (export "colors") (result i32 i32)
    (return (i32.const 200) (i32.const 58))
  )

  ;; Finds and returns the index of the first given `$chr` in the string
  ;; bound by the provided `$off` and `$len`.
  ;;
  ;; If the character is not found, `$len` is returned.
  (func $str.find (param $off i32) (param $len i32) (param $chr i32) (result i32)
    (local $i i32)

    (block $break
      (loop $continue
        ;; `while ($i < $len) & (slice($off, $len)[$i] != $chr)`
        (br_if $break
          (i32.or
            (i32.ge_u (local.get $i) (local.get $len))
            (i32.eq
              (i32.load8_u (i32.add (local.get $off) (local.get $i)))
              (local.get $chr)
            )
          )
        )
        ;; `$i += 1`
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $continue)
      )
    )

    (local.get $i)
  )

  ;; Returns `1` if the two given string slices are equal, `0` otherwise.
  (func $str.eq
    (param $off1 i32) (param $len1 i32)
    (param $off2 i32) (param $len2 i32)
    (result i32)

    (local $i i32)

    (if (i32.ne (local.get $len1) (local.get $len2))
      (then (return (i32.const 0)))
    )

    (block $break
      (loop $continue
        ;; `while $i < $len`
        (br_if $break (i32.ge_u (local.get $i) (local.get $len1)))
        (if
          ;; `slice($off1, $len1)[$i] != slice($off2, $len2)[$i]`
          (i32.ne
            (i32.load8_u (i32.add (local.get $off1) (local.get $i)))
            (i32.load8_u (i32.add (local.get $off2) (local.get $i)))
          )
          (then (return (i32.const 0)))
        )
        ;; `$i += 1`
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $continue)
      )
    )

    (i32.const 1)
  )

  ;; Given a valid resistor color, returns the associated value.
  (func (export "colorCode") (param $off i32) (param $len i32) (result i32)
    (local $i i32)
    (local $colsOff i32)
    (local $colsLen i32)
    (local $colsVarLen i32)
    (local $curColOff i32)
    (local $curColLen i32)

    (call $colors)
    (local.set $colsLen)
    (local.set $colsOff)

    (local.set $curColOff (local.get $colsOff))
    (local.set $colsVarLen (local.get $colsLen))

    (block $break
      ;; Loop while indices are valid and color string is not found.
      (loop $continue
        ;; `while $curColOff < $colsOff + $colsLen`
        (br_if $break
          (i32.ge_u
            (local.get $curColOff)
            (i32.add (local.get $colsOff) (local.get $colsLen))
          )
        )

        ;; Find current color end.
        ;; `$curColLen = slice($curColOff, $colsVarLen).find(',').or($colsVarLen)`
        (local.set $curColLen
          (call $str.find
            (local.get $curColOff)
            (local.get $colsVarLen)
            (i32.const 44)
          )
        )
        ;; Break if color string is found.
        ;; `if slice($curColOff, $curColLen) == slice($off, $len) { break; }`
        (br_if $break
          (call $str.eq
            (local.get $curColOff) (local.get $curColLen)
            (local.get $off) (local.get $len)
          )
        )

        ;; Update indices to mimic forward sub-slicing.
        ;; `$curColOff += $curColLen + 1`
        (local.set $curColOff
          (i32.add
            (local.get $curColOff)
            (i32.add
              (local.get $curColLen)
              (i32.const 1)
            )
          )
        )
        ;; `$colsVarLen -= $curColLen + 1`
        (local.set $colsVarLen
          (i32.sub
            (local.get $colsVarLen)
            (i32.add (local.get $curColLen) (i32.const 1))
          )
        )

        ;; `$i += 1`
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $continue)
      )
    )

    (local.get $i)
  )
)
