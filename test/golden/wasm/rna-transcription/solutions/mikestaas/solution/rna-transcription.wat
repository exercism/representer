(module
  (import "console" "log_i32_u" (func $log (param i32)))
  (memory
    (export "mem") 1)

  (func
    (export "toRna")
    (param $offset i32)
    (param $length i32)
    (result i32 i32)
    (local $i i32)
    (local $n i32)
    (local.set $i
      (i32.add
        (local.get $offset)
        (i32.sub
          (local.get $length)
          (i32.const 1))))
    (block $out
      (loop $loop
        (br_if $out
          (i32.lt_s
            (local.get $i)
            (local.get $offset)))
        (local.set $n
          (i32.load8_u
            (local.get $i)))
        (block $break
          (block $e
            (block $t
              (block $g
                (block $c
                  (block $a
                    (br_table $a $e $c $e $e $e $g $e $e $e $e $e $e $e $e $e $e $e $e $t $e
                      (i32.sub
                        (local.get $n)
                        (i32.const 65))))
                  (local.set $n
                    (i32.const 85))
                  (br $break))
                (local.set $n
                  (i32.const 71))
                (br $break))
              (local.set $n
                (i32.const 67))
              (br $break))
            (local.set $n
              (i32.const 65))
            (br $break)))
        (i32.store8
          (local.get $i)
          (local.get $n))
        (local.set $i
          (i32.sub
            (local.get $i)
            (i32.const 1)))
        (br $loop)))
    (return
      (local.get $offset)
      (local.get $length))
  )
)
