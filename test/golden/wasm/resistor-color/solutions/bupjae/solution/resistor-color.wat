(module
  (memory (export "mem") 1)

  (data (i32.const 100) "black,brown,red,orange,yellow,green,blue,violet,grey,white")

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
  (func (export "colorCode") (param $offset i32) (param $len i32) (result i32)
    (i32.const 100)
    (i32.load)
    (local.get $offset)
    (i32.load)
    (i32.eq)
    (if (then
      (i32.const 0)
      (return)
    ))
    
    (i32.const 106)
    (i32.load)
    (local.get $offset)
    (i32.load)
    (i32.eq)
    (if (then
      (i32.const 1)
      (return)
    ))

    (i32.const 112)
    (i32.load16_u)
    (local.get $offset)
    (i32.load16_u)
    (i32.eq)
    (if (then
      (i32.const 2)
      (return)
    ))

    (i32.const 116)
    (i32.load)
    (local.get $offset)
    (i32.load)
    (i32.eq)
    (if (then
      (i32.const 3)
      (return)
    ))

    (i32.const 123)
    (i32.load)
    (local.get $offset)
    (i32.load)
    (i32.eq)
    (if (then
      (i32.const 4)
      (return)
    ))

    (i32.const 130)
    (i32.load)
    (local.get $offset)
    (i32.load)
    (i32.eq)
    (if (then
      (i32.const 5)
      (return)
    ))

    (i32.const 136)
    (i32.load)
    (local.get $offset)
    (i32.load)
    (i32.eq)
    (if (then
      (i32.const 6)
      (return)
    ))

    (i32.const 141)
    (i32.load)
    (local.get $offset)
    (i32.load)
    (i32.eq)
    (if (then
      (i32.const 7)
      (return)
    ))

    (i32.const 148)
    (i32.load)
    (local.get $offset)
    (i32.load)
    (i32.eq)
    (if (then
      (i32.const 8)
      (return)
    ))

    (i32.const 153)
    (i32.load)
    (local.get $offset)
    (i32.load)
    (i32.eq)
    (if (then
      (i32.const 9)
      (return)
    ))

    (i32.const -1)
  )
)
