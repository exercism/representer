(module
  ;;
  ;; Calculate the square of the sum of the first N natural numbers
  ;;
  ;; @param {i32} max - The upper bound (inclusive) of natural numbers to consider
  ;;
  ;; @returns {i32} The square of the sum of the first N natural numbers
  ;;
  (func $squareOfSum (export "squareOfSum") (param $max i32) (result i32)
    (local $sum_of_max i32)
    
    (local.get $max)
    (call $sum)
    (local.set $sum_of_max)

    (local.get $sum_of_max)
    (local.get $sum_of_max)
    (i32.mul)
  )

  (func $sum (param $max i32) (result i32)
    (local.get $max)
    (i32.const 1)

    (if (result i32) (i32.lt_s)
      (then
        (local.get $max)
      )
      (else
        (local.get $max)
        (i32.const 1)
        (i32.sub)

        (call $sum)
        (local.get $max)
        (i32.add)
      )
    )
  )

  ;;
  ;; Calculate the sum of the squares of the first N natural numbers
  ;;
  ;; @param {i32} max - The upper bound (inclusive) of natural numbers to consider
  ;;
  ;; @returns {i32} The sum of the squares of the first N natural numbers
  ;;
  (func $sumOfSquares (export "sumOfSquares") (param $max i32) (result i32)
    (local.get $max)
    (i32.const 1)

    (if (result i32) (i32.le_s)
      (then
        (local.get $max)
      )
      (else
        (local.get $max)
        (i32.const 1)
        (i32.sub)

        (call $sumOfSquares)
        
        (local.get $max)
        (local.get $max)
        (i32.mul)
        
        (i32.add)
      )
    )
  )

  ;;
  ;; Calculate the difference between the square of the sum and the sum of the 
  ;; squares of the first N natural numbers.
  ;;
  ;; @param {i32} max - The upper bound (inclusive) of natural numbers to consider
  ;;
  ;; @returns {i32} Difference between the square of the sum and the sum of the
  ;;                squares of the first N natural numbers.
  ;;
  (func (export "difference") (param $max i32) (result i32)
    (local.get $max)
    (call $squareOfSum)

    (local.get $max)
    (call $sumOfSquares)

    (i32.sub)
  )
)
