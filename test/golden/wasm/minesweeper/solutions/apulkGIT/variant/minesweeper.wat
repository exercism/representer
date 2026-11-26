(module
  (memory (export "mem") 1)

  (func $getlen (param $inputoffset i32) (param $inputlength i32) (result i32) 
    (local $char i32)
    (local $i i32)
    (loop $lenloop
      (local.set $char (i32.load8_u (i32.add (local.get $inputoffset) (local.get $i))))
      (if (i32.and (i32.ne (local.get $char) (i32.const 10)) (i32.ne (local.get $char) (i32.const 0)))
      (then
        (local.set $i (i32.add (local.get $i) (i32.const 1)))  
        (br_if $lenloop (i32.eq (local.get $inputlength) (local.get $i)))
      ))
    )
    (return (local.get $i))
  )

  (func $calculatebombs (param $offset i32) (param $lenx i32) (param $leny i32) (param $x i32) (param $y i32) (result i32)
    (local $bombs i32)
    (if (i32.gt_s (local.get $y) (i32.const 0))
    (then
      (if (i32.gt_s (local.get $x) (i32.const 0))
      (then
        (if (i32.eq (i32.load8_u(i32.add (local.get $offset) (i32.add (i32.mul (i32.sub(local.get $y) (i32.const 1)) (local.get $lenx)) (i32.sub (local.get $x) (i32.const 1))))) (i32.const 42))
        (then
          (local.set $bombs (i32.add (local.get $bombs) (i32.const 1)))
        ))
      ))
      (if (i32.eq (i32.load8_u(i32.add (local.get $offset) (i32.add (i32.mul (i32.sub(local.get $y) (i32.const 1)) (local.get $lenx)) (local.get $x)))) (i32.const 42))
      (then
        (local.set $bombs (i32.add (local.get $bombs) (i32.const 1)))
      ))
      (if (i32.lt_s (local.get $x) (i32.sub (local.get $lenx) (i32.const 1)))
      (then
        (if (i32.eq (i32.load8_u(i32.add (local.get $offset) (i32.add (i32.mul (i32.sub(local.get $y) (i32.const 1)) (local.get $lenx)) (i32.add (local.get $x) (i32.const 1))))) (i32.const 42))
        (then
          (local.set $bombs (i32.add (local.get $bombs) (i32.const 1)))
        ))
      ))
    ))
    (if (i32.gt_s (local.get $x) (i32.const 0))
    (then
      (if (i32.eq (i32.load8_u(i32.add (local.get $offset) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (i32.sub (local.get $x) (i32.const 1))))) (i32.const 42))
      (then
        (local.set $bombs (i32.add (local.get $bombs) (i32.const 1)))
      ))
    ))
    (if (i32.lt_s (local.get $x) (i32.sub (local.get $lenx) (i32.const 1)))
    (then
      (if (i32.eq (i32.load8_u(i32.add (local.get $offset) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (i32.add (local.get $x) (i32.const 1))))) (i32.const 42))
      (then
        (local.set $bombs (i32.add (local.get $bombs) (i32.const 1)))
      ))
    ))
    (if (i32.lt_s (local.get $y) (i32.sub (local.get $leny) (i32.const 1)))
    (then
      (if (i32.gt_s (local.get $x) (i32.const 0))
      (then
        (if (i32.eq (i32.load8_u(i32.add (local.get $offset) (i32.add (i32.mul (i32.add(local.get $y) (i32.const 1)) (local.get $lenx)) (i32.sub (local.get $x) (i32.const 1))))) (i32.const 42))
        (then
          (local.set $bombs (i32.add (local.get $bombs) (i32.const 1)))
        ))
      ))
      (if (i32.eq (i32.load8_u(i32.add (local.get $offset) (i32.add (i32.mul (i32.add(local.get $y) (i32.const 1)) (local.get $lenx)) (local.get $x)))) (i32.const 42))
      (then
        (local.set $bombs (i32.add (local.get $bombs) (i32.const 1)))
      ))
      (if (i32.lt_s (local.get $x) (i32.sub (local.get $lenx) (i32.const 1)))
      (then
        (if (i32.eq (i32.load8_u(i32.add (local.get $offset) (i32.add (i32.mul (i32.add(local.get $y) (i32.const 1)) (local.get $lenx)) (i32.add (local.get $x) (i32.const 1))))) (i32.const 42))
        (then
          (local.set $bombs (i32.add (local.get $bombs) (i32.const 1)))
        ))
      ))
    ))
    (return (local.get $bombs))
  )
  ;;
  ;; Adds numbers to a minesweeper board.
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the output string in linear memory
  ;;
  (func (export "annotate") (param $offset i32) (param $length i32) (result i32 i32)
    (local $lenx i32)
    (local $leny i32)
    (local $x i32)
    (local $y i32)
    (local $dest i32)
    (local $count i32)
    (local.set $lenx (i32.add(call $getlen (local.get $offset) (local.get $length)) (i32.const 1)))
    (local.set $leny (i32.div_u (local.get $length) (local.get $lenx)))

    (local.set $dest (i32.const 512))
    (local.set $y (i32.const 0))
    (loop $loopy
      (if (i32.ne (local.get $y) (local.get $leny))
      (then
        (local.set $x (i32.const 0))   
        (loop $loopx
          (if (i32.ne (local.get $x) (i32.sub(local.get $lenx) (i32.const 1)))
          (then
            (if (i32.eq (i32.load8_u(i32.add (local.get $offset) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (local.get $x)))) (i32.const 32))
            (then
              (local.set $count (call $calculatebombs (local.get $offset) (local.get $lenx) (local.get $leny) (local.get $x) (local.get $y)))
              (if (i32.ne (local.get $count) (i32.const 0))
              (then
                (i32.store8(i32.add (local.get $dest) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (local.get $x))) (i32.add (i32.const 48) (local.get $count)))
              )
              (else
                (i32.store8(i32.add (local.get $dest) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (local.get $x))) (i32.const 32))
              ))
            )
            (else
              (i32.store8(i32.add (local.get $dest) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (local.get $x))) (i32.const 42))
            ))
            (local.set $x (i32.add (local.get $x) (i32.const 1)))
            (br $loopx)
          ))
        )
        (i32.store8(i32.add (local.get $dest) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (i32.sub (local.get $lenx) (i32.const 1)))) (i32.const 10))
        (local.set $y (i32.add (local.get $y) (i32.const 1)))
        (br $loopy)
      ))
    )
    (return (local.get $dest) (local.get $length))
  )
)
