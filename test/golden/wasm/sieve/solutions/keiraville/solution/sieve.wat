(module
  (memory (export "mem") 1)

  ;;
  ;; Determine all the prime numbers below a given limit.
  ;; Return the offset and length of the resulting array of primes.
  ;;
  ;; @param {i32} limit - the upper bound for the prime numbers
  ;;
  ;; @return {i32} - offset off the u32[] array
  ;; @return {i32} - length off the u32[] array in elements
  ;;
  (func (export "primes") (param $limit i32) (result i32 i32)
    (local $offset i32)
    (local $dest i32)
    (local $p i32)
    (local $m i32)

    ;; greater than $limit, and a multiple of 4
    (local.set $offset (i32.shl (i32.add (i32.shr_u (local.get $limit)
                                                    (i32.const 2))
                                         (i32.const 1))
                                (i32.const 2)))
    (local.set $dest (local.get $offset))

    (local.set $p (i32.const 0))
    (loop $init
      (if (i32.lt_u (local.get $p) (local.get $offset)) (then
        (i32.store (local.get $p) (i32.const 0))
        (local.set $p (i32.add (local.get $p)
                               (i32.const 4)))
        (br $init)
      ))
    )

    (local.set $p (i32.const 1))

    (loop $outer
      (local.set $p (i32.add (local.get $p) (i32.const 1)))
      (if (i32.le_u (local.get $p)
                    (local.get $limit)) (then
        (if (i32.load8_u (local.get $p)) (then
          (br $outer)
        ))
        (i32.store (local.get $dest) (local.get $p))
        (local.set $dest (i32.add (local.get $dest) (i32.const 4)))

        (local.set $m (i32.mul (local.get $p) (local.get $p)))

        (loop $inner
          (if (i32.le_u (local.get $m) (local.get $limit)) (then
            (i32.store8 (local.get $m) (i32.const 1))
            (local.set $m (i32.add (local.get $m) (local.get $p)))
            (br $inner)
          ))
        )

        (br $outer)
      ))
    )

    (return (local.get $offset)
            (i32.shr_u (i32.sub (local.get $dest) (local.get $offset))
                       (i32.const 2)))
  )
)
