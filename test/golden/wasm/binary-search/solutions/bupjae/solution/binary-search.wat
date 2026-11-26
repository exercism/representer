(module
  (memory (export "mem") 1)

  ;; Assumes size of i32
  (func (export "find") (param $base i32) (param $nelems i32) (param $needle i32) (result i32)
    (local $left i32)
    (local $right i32)
    (local $mid i32)
    (local $tmp i32)

    (local.get $nelems)
    (i32.eqz)
    (if (then (i32.const -1) (return)))

    (i32.const 0)
    (local.set $left)
    (local.get $nelems)
    (i32.const 1)
    (i32.sub)
    (local.set $right)

    (loop $loop
      (local.get $base)
      (local.get $left)
      (local.get $right)
      (i32.add)
      (i32.const 2)
      (i32.div_u)
      (local.tee $mid)
      (i32.const 4)
      (i32.mul)
      (i32.add)
      (i32.load)
      (local.tee $tmp)

      (local.get $needle)
      (i32.eq)
      (if (then (local.get $mid) (return)))

      (local.get $tmp)
      (local.get $needle)
      (i32.gt_s)
      (if (then
        (local.get $mid)
        (i32.const 1)
        (i32.sub)
        (local.set $right)
      ) (else
        (local.get $mid)
        (i32.const 1)
        (i32.add)
        (local.set $left)
      ))

      (local.get $left)
      (local.get $right)
      (i32.le_s)
      (br_if $loop)
    )

    (i32.const -1)
  )
)
