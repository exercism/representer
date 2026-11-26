(module
  (import "console" "log_i32_u" (func $log_i32_u (param i32)))
  (memory (export "mem") 1)
 
  ;;
  ;; Find the first occurrence of the needle in the haystack
  ;;
  ;; @param {i32} base - the base address of the haystack
  ;; @param {i32} nelems - the number of elements in the haystack
  ;; @param {i32} needle - the value to search for
  ;;
  ;; @return {i32} the index of the first occurrence of the needle in the haystack
  ;;               or -1 if the needle is not found.
  ;;
  (func (export "find") (param $base i32) (param $nelems i32) (param $needle i32) (result i32)
    (local $tmp i32)
    (local $mid i32)
    (local $left i32)
    (local $right i32)
    (if (i32.eqz (local.get $nelems)) (then (return (i32.const -1))))
    (local.set $right (i32.sub (local.get $nelems) (i32.const 1)))
    (block
      (loop
        (br_if 1 (i32.gt_s (local.get $left) (local.get $right)))
        (local.set $mid (i32.div_u (i32.add (local.get $right) (local.get $left)) (i32.const 2)))
        (local.set $tmp (i32.load (i32.add (local.get $base) (i32.mul (local.get $mid) (i32.const 4)))))
        (if (i32.eq (local.get $tmp) (local.get $needle))
          (then (return (local.get $mid)))
          (else (if (i32.lt_u (local.get $tmp) (local.get $needle))
            (then
              (local.set $left (i32.add (local.get $mid) (i32.const 1)))
            )
            (else
              (local.set $right (i32.sub (local.get $mid) (i32.const 1)))
            )
          ))
        )
        (br 0)
      )
    )
    (return (i32.const -1))
  )
)
