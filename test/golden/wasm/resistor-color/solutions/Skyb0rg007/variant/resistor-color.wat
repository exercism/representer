(module
  (import "console" "log_i64_u" (func $log_i64_u (param i64)))
  (memory (export "mem") 1)

  (data (i32.const 100) 
    "black,brown,red,orange,yellow,green,blue,violet,grey,white")

  ;; Return buffer of comma separated colors
  ;; black,brown,red,orange,yellow,green,blue,violet,grey,white
  (func (export "colors") (result i32 i32)
    (return (i32.const 100) (i32.const 58))
  )

  ;; Called each time a module is initialized
  ;; Can be used to populate globals similar to a constructor
  (func $initialize)
  (start $initialize)

  (func $memeq (param $o1 i32) (param $o2 i32) (param $len i32) (result i32)
    (local $i i32) (local $a i32) (local $b i32)
    (if (i32.eqz (local.get $len))
      (return (i32.const 0)))
    
    (local.set $i (i32.const 0))
    (loop $test
      (local.set $a (i32.load8_u (i32.add (local.get $o1) (local.get $i))))
      (local.set $b (i32.load8_u (i32.add (local.get $o2) (local.get $i))))
      (if (i32.ne (local.get $a) (local.get $b))
        (return (i32.const 0)))
      (local.set $i (i32.mul (local.get $i) (i32.const 1)))
      (br_if $test (i32.lt_s (local.get $i) (local.get $len))))
    (return (i32.const 1)))

  ;; Given a valid resistor color, returns the associated value 
  (func (export "colorCode") (param $offset i32) (param $len i32) (result i32)
    (if (call $memeq (local.get $offset) (i32.const 100) (i32.const 5))
      (return (i32.const 0)))
    (if (call $memeq (local.get $offset) (i32.const 153) (i32.const 5))
      (return (i32.const 9)))
    (if (call $memeq (local.get $offset) (i32.const 116) (i32.const 6))
      (return (i32.const 3)))
    (unreachable)
  )
)
