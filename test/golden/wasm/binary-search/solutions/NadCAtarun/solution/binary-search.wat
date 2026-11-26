(module
  (memory (export "mem") 1)
  
  (func $find (export "find")
    (param $base i32) (param $nelems i32) (param $needle i32)
    (result i32)
    
    (local $pivotIndex i32)
    (local $pivotItem i32)
    (local $subIndex i32)

    ;; Empty haystack
    (if (i32.le_s (local.get $nelems) (i32.const 0)) (return (i32.const -1)))

    ;; Computing the pivot
    (local.set $pivotIndex (i32.shr_u (local.get $nelems) (i32.const 1)))
    (local.set $pivotItem
      (i32.load
        (i32.add
          (local.get $base)
          (i32.mul (local.get $pivotIndex) (i32.const 4))
        )
      )
    )

    ;; Pivot is the needle
    (if
      (i32.eq (local.get $needle) (local.get $pivotItem))
      (return (local.get $pivotIndex))
    )

    ;; Needle is smaller than the pivot, we look at the left part
    (if
      (i32.lt_u (local.get $needle) (local.get $pivotItem))
      (return
        (call $find
          (local.get $base)
          (local.get $pivotIndex)
          (local.get $needle)
        )
      )
    )

    ;; Needle is greater than the pivot, we look at the right part
    (local.set $subIndex
      (call $find
        (i32.add
          (local.get $base)
          (i32.mul 
            (i32.add (local.get $pivotIndex) (i32.const 1))
            (i32.const 4)
          )
        )
        (i32.sub (i32.sub (local.get $nelems) (local.get $pivotIndex)) (i32.const 1))
        (local.get $needle)
      )
    )

    ;; Needle found in the right part
    (if
      (i32.ge_s (local.get $subIndex) (i32.const 0))
      (return (i32.add (i32.add (local.get $pivotIndex) (local.get $subIndex)) (i32.const 1)))
    )

    ;; Needle not found    
    (i32.const -1)
  )
)
