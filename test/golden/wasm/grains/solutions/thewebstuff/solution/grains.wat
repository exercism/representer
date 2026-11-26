(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    (local $final i64) ;; initializes to 0
    (block $rangeInvalid
      ;; branch out if < 1 or > 64
      (i32.lt_s (local.get $squareNum) (i32.const 1))
      br_if $rangeInvalid
      (i32.gt_s (local.get $squareNum) (i32.const 64))
      br_if $rangeInvalid
      
      ;; otherwise take a bit and, for n-1 times, shift it left
      i64.const 1
      (i32.sub (local.get $squareNum) (i32.const 1))
      i64.extend_i32_u
      i64.shl
      
      local.set $final
    )
    local.get $final
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    i64.const -1 ;; -1 in two's-complement is an int with all the bits set
  )
)
