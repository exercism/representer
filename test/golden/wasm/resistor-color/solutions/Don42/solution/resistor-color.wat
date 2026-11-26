(module
  (import "console" "log_i32_u" (func $log (param i32)))
  (memory (export "mem") 1)

  (data 
    (i32.const 100) 
    "black,brown,red,orange,yellow,green,blue,violet,grey,white"
  )

  ;; Return buffer of comma separated colors
  ;; black,brown,red,orange,yellow,green,blue,violet,grey,white
  (func (export "colors") (result i32 i32)
    (return (i32.const 100) (i32.const 58))
  )

  ;; Called each time a module is initialized
  ;; Can be used to populate globals similar to a constructor
  (func $initialize)
  (start $initialize)

  ;; Given a valid resistor color, returns the associated value 
  (func
    (export "colorCode")
    (param $offset i32)
    (param $len i32)
    (result i32)

    ;; Precondition: The data given is actually a valid resistor code.
    ;; Check tree
    ;; if o[0] == b
    (local $first i32)
    (local $second i32)
    (local $third i32)
    (local $forth i32)

    (local.set $first (i32.load8_u (local.get $offset)))
    (if (i32.eq (local.get $first) (i32.const 98))
      (then
        ;; b
        (local.set $second 
          (i32.load8_u 
            (i32.add (local.get $offset) (i32.const 1))))
        (if (i32.eq (local.get $second) (i32.const 108))
          (then
            ;; bl
            (local.set $third 
              (i32.load8_u 
                (i32.add (local.get $offset) (i32.const 2))))
            (if (i32.eq (local.get $third) (i32.const 97))
              (then
                ;; bla -> Black
                (return (i32.const 0))
              )
              (else
                ;; Process of elimination: Blue
                (return (i32.const 6))
              )
            )
          )
          (else
            ;; Process of elimination: Brown
            (return (i32.const 1))
          )
        )
      )
    )
    (if (i32.eq (local.get $first) (i32.const 114))
      ;; Process of elimination: Red
      (return (i32.const 2))
    )
    (if (i32.eq (local.get $first) (i32.const 111))
      ;; Process of elimination: Orange
      (return (i32.const 3))
    )
    (if (i32.eq (local.get $first) (i32.const 121))
      ;; Process of elimination: Yellow
      (return (i32.const 4))
    )
    (if (i32.eq (local.get $first) (i32.const 103))
      ;; gre
      (then
        (local.set $forth
          (i32.load8_u 
            (i32.add (local.get $offset) (i32.const 3))))
        (if (i32.eq (local.get $forth) (i32.const 101))
          (then
            ;; Process of elimination: Green
            (return (i32.const 5))
          )
          (else
            ;; Process of elimination: Grey
            (return (i32.const 8))
          )
        )
      )
    )
    (if (i32.eq (local.get $first) (i32.const 118))
      ;; Process of elimination: Violet
      (return (i32.const 7))
    )
    (if (i32.eq (local.get $first) (i32.const 119))
      ;; Process of elimination: White
      (return (i32.const 9))
    )
    (return (i32.const -1))
  )
)
