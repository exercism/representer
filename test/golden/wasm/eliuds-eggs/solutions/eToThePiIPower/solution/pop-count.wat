(module
  (func (export "eggCount") (param $number i32) (result i32)
        (local $count i32)

        (loop $loop
              ;; put a 1 or zero on stack, depending on last bit of $number
              local.get $number
              i32.const 1
              i32.and

              ;; add the previous to the $count so far
              local.get $count
              i32.add
              local.set $count

              ;; shift $number right by 1 and contniue if $number =/= 0
              local.get $number
              i32.const 1
              i32.shr_u
              local.tee $number

              br_if $loop 
              )

        local.get $count
        return
        )
  )
