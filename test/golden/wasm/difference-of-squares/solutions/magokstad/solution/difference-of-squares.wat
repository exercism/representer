(module
  ;; The name prefixed with $ is used to internally refer to functions via the call instruction
  ;; The string in the export instruction is the name of the export made available to the
  ;; embedding environment (in this case, Node.js). This is used by our test runner Jest.
  (func $squareOfSum (export "squareOfSum") (param $max i32) (result i32)
    (local $i i32)
    (local $sum i32)
    (block $end (loop $body
      (local.set $i (i32.add (local.get $i) (i32.const 1))) ;; i++
      ;;

      (local.set $sum (i32.add (local.get $sum) (local.get $i))) ;; sum += i

      (br_if $end (i32.ge_u (local.get $i) (local.get $max))) ;; if (i >= max) break;
      (br $body) ;; loop
    ))
    (return (i32.mul (local.get $sum) (local.get $sum))) ;; return sum squared
  )

  (func $sumOfSquares (export "sumOfSquares") (param $max i32) (result i32)
    (local $i i32)
    (local $sum i32)
    (block $end (loop $body
      (local.set $i (i32.add (local.get $i) (i32.const 1))) ;; i++
      ;;

      (local.set $sum (i32.add (local.get $sum) (i32.mul (local.get $i) (local.get $i) ))) ;; sum += i^2

      (br_if $end (i32.ge_u (local.get $i) (local.get $max))) ;; if (i >= max) break;
      (br $body) ;; loop
    ))
    (return  (local.get $sum)) ;; return sum
  )

  (func (export "difference") (param $max i32) (result i32)
    (local $a i32)
    (local $b i32)
    (local.set $a (call $squareOfSum (local.get $max))) 
    (local.set $b (call $sumOfSquares (local.get $max))) 

    (if (i32.gt_s (local.get $a) (local.get $b))
      (then (return (i32.sub (local.get $a) (local.get $b) ) ) ))
    (return (i32.sub (local.get $b) (local.get $a) ) )
  )
)
