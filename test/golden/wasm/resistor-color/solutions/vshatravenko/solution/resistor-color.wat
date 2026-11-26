(module
  ;; Uncomment for debugging:
  ;; (import "console" "log_i32_u" (func $log_i32_u (param i32)))
  ;; (import "console" "log_mem_as_utf8" (func $log_mem_as_utf8 (param $byteOffset i32) (param $length i32)))

  (memory (export "mem") 1)

  (global $colorsOffset i32 (i32.const 100))
  (global $colorsLength i32 (i32.const 58)) ;; sum of all color lengths below(including commas)

  (data (i32.const 100) "black,brown,red,orange,yellow,green,blue,violet,grey,white")

  ;; Return buffer of comma separated colors
  ;; black,brown,red,orange,yellow,green,blue,violet,grey,white
  (func (export "colors") (result i32 i32)
    (global.get $colorsOffset) (global.get $colorsLength)
  )

  ;; Given a valid resistor color, returns the associated value
  ;; Algo - iterate through all colors stored in data,
  ;; resetting comparisons when a comma char is encountered
  ;; return the counter value
  (func (export "colorCode") (param $offset i32) (param $len i32) (result i32)
    (local $memIdx i32) ;; used for color memory block lookup
    (local $paramIdx i32) ;; used for param traversal
    (local $colorIdx i32) ;; used to keep track of a given color's index
    (local $memChar i32)
    (local $paramChar i32)
    (local $commaChar i32)

    (local.set $commaChar (i32.load8_u (i32.const 105)))

    (loop $main
      (local.set $memChar (i32.load8_u (i32.add (global.get $colorsOffset) (local.get $memIdx))))
      (local.set $paramChar (i32.load8_u (i32.add (local.get $offset) (local.get $paramIdx))))

      ;; Uncomment for debugging:
      ;; (call $log_mem_as_utf8 (i32.add (global.get $colorsOffset) (local.get $memIdx)) (i32.const 1))
      ;; (call $log_mem_as_utf8 (i32.add (local.get $offset) (local.get $paramIdx)) (i32.const 1))

      (if (i32.or (i32.eq (local.get $memChar) (local.get $commaChar)) (i32.eq (local.get $memIdx) (global.get $colorsLength)))
        (then
          (return (local.get $colorIdx))
        )
        (else
          (if (i32.ne (local.get $paramChar) (local.get $memChar))
            (then
              (local.set $paramIdx (i32.const -1)) ;; because it's incremented at the end of the loop
              (local.set $colorIdx (call $inc (local.get $colorIdx)))

              (loop $nextColor
                (local.set $memIdx (call $inc (local.get $memIdx)))
                (br_if $nextColor (i32.and
                  (i32.ne (local.get $commaChar) (i32.load8_u (i32.add (global.get $colorsOffset) (local.get $memIdx))))
                  (i32.lt_u (local.get $memIdx) (global.get $colorsLength))
                  )
                )
              )
            )
          )
        )
      )

      (local.set $memIdx (call $inc (local.get $memIdx)))
      (local.set $paramIdx (call $inc (local.get $paramIdx)))
      (br_if $main (i32.le_u (local.get $memIdx) (global.get $colorsLength)))
    )

    (return (i32.const -1))
  )

  ;; Finally, increment func
  (func $inc (param $num i32) (result i32)
    (i32.add (local.get $num) (i32.const 1))
  )
)
