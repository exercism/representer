(module
;;  (import "console" "log_i32_u" (func $log_i32_u (param i32)))

  (memory (export "mem") 1)

  (data (i32.const 100) "black")
  (data (i32.const 110) "brown")
  (data (i32.const 120) "red")
  (data (i32.const 130) "orange")
  (data (i32.const 140) "yellow")
  (data (i32.const 150) "green")
  (data (i32.const 160) "blue")
  (data (i32.const 170) "violet")
  (data (i32.const 180) "grey")
  (data (i32.const 190) "white")
  (data (i32.const 200) "black,brown,red,orange,yellow,green,blue,violet,grey,white")

  ;; Return buffer of comma separated colors
  ;; black,brown,red,orange,yellow,green,blue,violet,grey,white
  (func (export "colors") (result i32 i32)
    (return (i32.const 200) (i32.const 58))
  )

  ;; Called each time a module is initialized
  ;; Can be used to populate globals similar to a constructor
  (func $initialize)
  (start $initialize)

  ;; Given a valid resistor color, returns the associated value 
  (func (export "colorCode") (param $offset i32) (param $len i32) (result i32)
    (local $color_index i32)
    (local $nb_colors i32)

    (local $data_offset i32)

    (local $name_index i32)
    (local $data_char i32)
    (local $param_char i32)

    ;; loop on color index: 0 to 9
    (local.set $nb_colors (i32.const 10))
    (local.set $color_index (i32.const 0))
    (loop $color_loop
      (if (i32.gt_u (local.get $nb_colors) (local.get $color_index))
        (then
          ;; data offset for color i: 100 + (10 * i)
          (local.set $data_offset (i32.add (i32.const 100) (i32.mul (i32.const 10) (local.get $color_index))))

          (block $name_match
            ;; loop on color name characters
            (local.set $name_index (i32.const 0))
            (loop $name_loop
              (if (i32.gt_u (local.get $len) (local.get $name_index))
                (then
                  ;; data character value
                  (local.set $data_char (i32.load8_u (i32.add (local.get $data_offset) (local.get $name_index))))
                  ;; parameter character value
                  (local.set $param_char (i32.load8_u (i32.add (local.get $offset) (local.get $name_index))))

                  ;; if chars are different, we move to the next color
                  (if (i32.ne (local.get $data_char) (local.get $param_char))
                    (then (br $name_match)) (else))

                  (local.set $name_index (i32.add (local.get $name_index) (i32.const 1)))
                  (br $name_loop)
                ) (else)
              )
            )
            ;; if we get here this means the the 2 names match => we can return the color index
            (return (local.get $color_index))
          )

          (local.set $color_index (i32.add (local.get $color_index) (i32.const 1)))
          (br $color_loop)
        ) (else)
      )
    )
    ;; if we reach this point this means that no matching name was found
    (return (i32.const -1))
  )
)
