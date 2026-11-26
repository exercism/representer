(module
  (memory (export "mem") 1)

  ;;
  ;; Provide the numbers for Pascals triangle with a given number of rows
  ;;
  ;; @param {i32} $count - number of rows
  ;;
  ;; @returns {(i32,i32)} - offset and length of the i32-numbers in linear memory
  ;;
  (func (export "rows") (param $count i32) (result i32 i32)
    (local $row i32)
    (local $col i32)
    (local $len i32)
    (local $pre i32)
    (local.set $row
      (i32.const 1))
    (loop $outer
      (i32.store
        (i32.shl
          (local.get $len)
          (i32.const 2))
        (local.tee $pre
          (local.tee $col
            (i32.const 1))))
      (local.set $len
        (i32.add
          (local.get $len)
          (i32.const 1)))
      (block $out
        (loop $inner
          (br_if $out
            (i32.ge_u
              (local.get $col)
              (local.get $row)))
          (i32.store
            (i32.shl
              (local.get $len)
              (i32.const 2))
            (local.tee $pre
              (i32.div_u
                (i32.mul
                  (local.get $pre)
                  (i32.sub
                    (local.get $row)
                    (local.get $col)))
                (local.get $col))))
          (local.set $len
            (i32.add
              (local.get $len)
              (i32.const 1)))
          (local.set $col
            (i32.add
              (local.get $col)
              (i32.const 1)))
          (br $inner)))
      (br_if $outer
        (i32.le_u
          (local.tee $row
            (i32.add
              (local.get $row)
              (i32.const 1)))
          (local.get $count))))
    (i32.const 0)
    (local.get $len))
)