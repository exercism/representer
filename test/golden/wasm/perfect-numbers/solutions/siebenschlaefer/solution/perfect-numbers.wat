(module
  (global $non_positive i32 (i32.const 0))
  (global $deficient i32 (i32.const 1))
  (global $perfect i32 (i32.const 2))
  (global $abundant i32 (i32.const 3))

  ;;
  ;; Determine whether a number is abundant, deficient, or perfect.
  ;;
  ;; @param {i32} n - The number to check
  ;; @returns {i32} the classification as an integer (see the global constants)
  ;;
  (func (export "classify") (param $n i32) (result i32)
    (local $aliquot_sum i32)

    ;; handle non-positive numbers
    (if (i32.le_s (local.get $n) (i32.const 0))
      (then (return (global.get $non_positive))))

    ;; calculate the aliquot sum
    (local.set $aliquot_sum (call $calculate_aliquot_sum (local.get $n)))

    ;; determine the result
    (if (i32.lt_s (local.get $aliquot_sum) (local.get $n))
      (then (return (global.get $deficient))))
    (if (i32.gt_s (local.get $aliquot_sum) (local.get $n))
      (then (return (global.get $abundant))))
    (global.get $perfect)
  )

  ;;
  ;; Calculate the "aliquot sum" of a postive integer,
  ;; i.e. the sum of factors other than the number itself.
  ;;
  (func $calculate_aliquot_sum (param $n i32) (result i32)
    (local $sum i32)
    (local $i i32)

    ;; edge case: 1 has no other factors than itself
    (if (i32.eq (local.get $n) (i32.const 1))
      (then (return (i32.const 0))))

    ;; loop over the range [2..sqrt($n))
    (local.set $sum (i32.const 1))
    (local.set $i (i32.const 2))
    (block $loop_end (loop $loop
      (br_if $loop_end (i32.le_u (local.get $n) (i32.mul
        (local.get $i) (local.get $i))))

      ;; if $i is a factor of $n
      (if (i32.eqz (i32.rem_s (local.get $n) (local.get $i)))
        (then
          ;; add $i and $n/$i to the aliquot sum
          (local.set $sum (i32.add (local.get $sum) (local.get $i)))
          (local.set $sum (i32.add (local.get $sum (i32.div_s
            (local.get $n) (local.get $i)))))
      ))

      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br $loop)
    ))

    ;; if $n is a perfect square (i.e. if $i * $i == $n)
    (if (i32.eq (local.get $n) (i32.mul (local.get $i) (local.get $i)))
      (then
        ;; add $i to the aliquot sum
        (local.set $sum (i32.add (local.get $sum) (local.get $i)))
    ))

    (local.get $sum)
  )
)