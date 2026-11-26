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
        (br_if $lenloop (i32.ne (local.get $inputlength) (local.get $i)))
      ))
    )
    (return (local.get $i))
  )

  (func $calcrect (param $inputOffset i32) (param $lenx i32) (param $leny i32) (param $i i32) (param $k i32) (param $j i32) (result i32)
    (local $x i32)
    (local $y i32)
    (local $char i32)
    (local $char2 i32)
    (local $y2 i32)
    (local $rectangles i32)

    (local.set $y (i32.add (local.get $i) (i32.const 1)))
    (loop $rectloop
      (local.set $char (i32.load8_u(i32.add (local.get $inputOffset) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (local.get $k)))))
      (local.set $char2 (i32.load8_u(i32.add (local.get $inputOffset) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (local.get $j)))))
      (if (i32.and (i32.eq (local.get $char) (i32.const 43)) (i32.eq (local.get $char2) (i32.const 43)))
      (then
        (local.set $x (i32.add (local.get $k) (i32.const 1)))
        (loop $rectloopinner
          (if (i32.lt_s (local.get $x) (local.get $j))
          (then
            (local.set $char (i32.load8_u(i32.add (local.get $inputOffset) (i32.add (i32.mul (local.get $y) (local.get $lenx)) (local.get $x)))))
            (local.set $x (i32.add (local.get $x) (i32.const 1)))
            (br_if $rectloopinner (i32.or (i32.eq(local.get $char) (i32.const 43)) (i32.eq(local.get $char) (i32.const 45))))
          ))
        )
        (if (i32.or (i32.eq(local.get $char) (i32.const 43)) (i32.eq(local.get $char) (i32.const 45)))
        (then
          (local.set $char (i32.const 43))
          (local.set $y2 (i32.add (local.get $i) (i32.const 1)))
          (loop $rectloopinner2
            (if (i32.lt_s (local.get $y2) (local.get $y))
            (then
              (local.set $char (i32.load8_u(i32.add (local.get $inputOffset) (i32.add (i32.mul (local.get $y2) (local.get $lenx)) (local.get $k)))))
              (local.set $y2 (i32.add (local.get $y2) (i32.const 1)))
              (br_if $rectloopinner2 (i32.or (i32.eq(local.get $char) (i32.const 43)) (i32.eq(local.get $char) (i32.const 124))))
            ))
          )
          (if (i32.or (i32.eq(local.get $char) (i32.const 43)) (i32.eq(local.get $char) (i32.const 124)))
          (then
            (local.set $char (i32.const 43))
            (local.set $y2 (i32.add (local.get $i) (i32.const 1)))
            (loop $rectloopinner3
              (if (i32.lt_s (local.get $y2) (local.get $y))
              (then
                (local.set $char (i32.load8_u(i32.add (local.get $inputOffset) (i32.add (i32.mul (local.get $y2) (local.get $lenx)) (local.get $j)))))
                (local.set $y2 (i32.add (local.get $y2) (i32.const 1)))
                (br_if $rectloopinner3 (i32.or (i32.eq(local.get $char) (i32.const 43)) (i32.eq(local.get $char) (i32.const 124))))
              ))
            )
            (if (i32.or (i32.eq(local.get $char) (i32.const 43)) (i32.eq(local.get $char) (i32.const 124)))
            (then
              (local.set $rectangles (i32.add (local.get $rectangles) (i32.const 1)))
            ))
          ))
        ))
      ))
      (local.set $y (i32.add (local.get $y) (i32.const 1)))
      (br_if $rectloop (i32.ne (local.get $y) (local.get $leny)))
    )
    (return (local.get $rectangles))
  )
  ;;
  ;; Count the rectangles in a grid with lines each ending with line breaks
  ;;
  ;; @param {i32} inputOffset - offset of the grid in linear memory
  ;; @param {i32} inputLength - length of the grid in linear memory
  ;;
  ;; @returns {i32} - number of rectangles in the grid
  ;;
  (func (export "count") (param $inputOffset i32) (param $inputLength i32) (result i32)
    (local $i i32)
    (local $j i32)
    (local $k i32)
    (local $lenx i32)
    (local $leny i32)
    (local $char i32)
    (local $rectangles i32)

    (local.set $lenx (i32.add (call $getlen (local.get $inputOffset) (local.get $inputLength)) (i32.const 1)))
    (local.set $leny (i32.div_u (local.get $inputLength) (local.get $lenx)))

    (loop $countloopy
      (local.set $j (i32.const 0))
      (loop $countloopx 
        (loop $countloopxinner
          (local.set $char (i32.load8_u(i32.add (local.get $inputOffset) (i32.add (i32.mul (local.get $i) (local.get $lenx)) (local.get $j)))))
          (if (i32.and (i32.ne(local.get $char) (i32.const 43)) (i32.ne(local.get $char) (i32.const 10)))
          (then
            (local.set $j (i32.add (local.get $j) (i32.const 1)))
            (br_if $countloopxinner (i32.ne (local.get $lenx) (local.get $j)))
          ))
        )
        (local.set $k (local.get $j))
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (if (i32.eq(local.get $char) (i32.const 43))
        (then
          (loop $countloopxinner2
            (loop $countloopxinner3
              (local.set $char (i32.load8_u(i32.add (local.get $inputOffset) (i32.add (i32.mul (local.get $i) (local.get $lenx)) (local.get $j)))))
              (if (i32.ne(local.get $char) (i32.const 45))
              (then
                (local.set $j (i32.add (local.get $j) (i32.const 1)))
                (br_if $countloopxinner3 (i32.ne (local.get $lenx) (local.get $j)))
              ))
            )
            (if (i32.eq(local.get $char) (i32.const 43))
            (then
              (local.set $rectangles (i32.add (local.get $rectangles) (call $calcrect (local.get $inputOffset) (local.get $lenx) (local.get $leny) (local.get $i) (local.get $k) (local.get $j))))
            ))
            (local.set $j (i32.add (local.get $j) (i32.const 1)))
             (br_if $countloopxinner2 (i32.and (i32.ne(local.get $char) (i32.const 32)) (i32.ne(local.get $char) (i32.const 10))))
          )
        ))
        (local.set $j (i32.add(local.get $k) (i32.const 1)))
        (br_if $countloopx (i32.lt_s (local.get $j) (local.get $lenx)))
      )
      (local.set $i (i32.add(local.get $i) (i32.const 1)))
      (br_if $countloopy (i32.lt_s (local.get $i) (i32.sub (local.get $leny) (i32.const 1))))
    )
    (return (local.get $rectangles))
  )
)