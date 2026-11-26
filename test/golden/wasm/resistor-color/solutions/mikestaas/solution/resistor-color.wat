(module
  (global $data_start i32
    (i32.const 192))
  (global $data_len i32
    (i32.const 58))
  (global $table_start i32
    (i32.const 256))
  (global $table_len i32
    (i32.const 22)) ;; smallest table size for the data with no collision
  (memory (export "mem") 1)

  (data (i32.const 192) "black,brown,red,orange,yellow,green,blue,violet,grey,white,")

  ;; Return buffer of comma separated colors
  ;; black,brown,red,orange,yellow,green,blue,violet,grey,white
  (func
    (export "colors")
    (result i32 i32)
    (return
      (global.get $data_start)
      (global.get $data_len)))

  (func $hash
    (param $start i32)
    (param $len i32)
    (result i32)
    (local $res i32)
    (local $i i32)
    (local.set $res
      (i32.const 5381))
    (loop $loop
      (local.set $res
        (i32.add
          (i32.add
            (i32.shl
              (local.get $res)
              (i32.const 5))
            (local.get $res))
          (i32.load8_u
            (i32.add
              (local.get $start)
              (local.get $i)))))
      (br_if $loop
        (i32.lt_u
          (local.tee $i
            (i32.add
              (local.get $i)
              (i32.const 1)))
          (local.get $len))))
    (local.get $res))
  (func $index
    (param $start i32)
    (param $len i32)
    (result i32)
    (i32.add
      (global.get $table_start)
      (i32.mul
        (i32.rem_u
          (call $hash
            (local.get $start)
            (local.get $len))
          (global.get $table_len))
        (i32.const 4))))
  (func $add_entry
    (param $location i32)
    (param $i i32)
    (param $start i32)
    (param $len i32)
    (i32.store8
      (local.get $location)
      (local.get $i))
    (i32.store8
      (i32.add
        (local.get $location)
        (i32.const 1))
      (local.get $start))
    (i32.store8
      (i32.add
        (local.get $location)
        (i32.const 2))
      (local.get $len)))
  (func $get_entry
    (param $location i32)
    (result i32 i32 i32)
    (i32.load8_u
      (local.get $location))
    (i32.load8_u
      (i32.add
        (local.get $location)
        (i32.const 1)))
    (i32.load8_u
      (i32.add
        (local.get $location)
        (i32.const 2))))

;; Called each time a module is initialized
  ;; Can be used to populate globals similar to a constructor
  (func $initialize
    (local $start i32)
    (local $len i32)
    (local $end i32)
    (local $c i32)
    (local $i i32)
    (local.set $c
      (local.tee $start
        (global.get $data_start)))
    (local.set $end
      (i32.add
        (global.get $data_start)
        (global.get $data_len)))
    (loop $loop
      (if
        (i32.eq
          (i32.load8_u
            (local.get $c))
          (i32.const 44)) ;; ','
        (then
          (local.set $len
            (i32.sub
              (local.get $c)
              (local.get $start)))
          (call $add_entry
            (call $index
              (local.get $start)
              (local.get $len))
            (local.get $i)
            (local.get $start)
            (local.get $len))
          (local.set $start
            (i32.add
              (local.get $c)
              (i32.const 1)))
          (local.set $i
            (i32.add
              (local.get $i)
              (i32.const 1)))))
      (br_if $loop
        (i32.le_u
          (local.tee $c
            (i32.add
              (local.get $c)
              (i32.const 1)))
          (local.get $end)))))
  (start $initialize)

  ;; Given a valid resistor color, returns the associated value 
  (func $str_cmp
    (param $a i32)
    (param $b i32)
    (param $len i32)
    (result i32)
    (local $i i32)
    (loop $loop
      (if
        (i32.ne
          (i32.load8_u
            (i32.add
              (local.get $a)
              (local.get $i)))
          (i32.load8_u
            (i32.add
              (local.get $b)
              (local.get $i))))
        (then
          (return
            (i32.const 0))))
      (br_if $loop
        (i32.lt_u
          (local.tee $i
            (i32.add
              (local.get $i)
              (i32.const 1)))
          (local.get $len))))
    (i32.const 1))
  (func
    (export "colorCode")
    (param $offset i32)
    (param $len i32)
    (result i32)
    (local $i i32)
    (local $start i32)
    (local $len2 i32)
    (local.set $i
      (local.set $start
        (local.set $len2
          (call $get_entry
            (call $index
              (local.get $offset)
              (local.get $len))))))
    (if
      (i32.eq
        (local.get $len)
        (local.get $len2))
      (then
        (if
          (call $str_cmp
            (local.get $offset)
            (local.get $start)
            (local.get $len))
          (then
            (return
              (local.get $i))))))
    (i32.const -1))
)
