(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    (local $r i64)

    (local $i i32)

    (i32.const 1)
    (local.set $i)

    (i64.const 1)
    (local.set $r)

    (if (i32.or
          (i32.le_s (local.get $squareNum) (i32.const 0))
          (i32.gt_s (local.get $squareNum) (i32.const 64)) )
      (then
        (return (i64.const 0))
    ))

    (block $loop_exit
      (loop $loop_next
        (i32.ge_s (local.get $i) (local.get $squareNum))
        (br_if $loop_exit)
              
        (i64.mul (local.get $r) (i64.const 2))             
        (local.set $r)

        (i32.add (i32.const 1) (local.get $i))      
        (local.set $i)

        (br $loop_next)
    ))

    (local.get $r)
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    (local $r i64)

    (local $i i32)

    (i32.const 1)
    (local.set $i)

    (i64.const 0)
    (local.set $r)

    (block $loop_exit
      (loop $loop_next             
        (i64.add (local.get $r) (call $square (local.get $i)))             
        (local.set $r)

        (i32.add (i32.const 1) (local.get $i))      
        (local.set $i)

        (i32.gt_s (local.get $i) (i32.const 64))
        (br_if $loop_exit)
        (br $loop_next)
    ))
    
    (local.get $r)
  )
)
