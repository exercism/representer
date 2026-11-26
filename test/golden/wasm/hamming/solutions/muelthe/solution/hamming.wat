(module
  (memory (export "mem") 1)

  ;;
  ;; Calculate the hamming distance between two strings.
  ;;
  ;; @param {i32} firstOffset - The offset of the first string in linear memory.
  ;; @param {i32} firstLength - The length of the first string in linear memory.
  ;; @param {i32} secondOffset - The offset of the second string in linear memory.
  ;; @param {i32} secondLength - The length of the second string in linear memory.
  ;;
  ;; @returns {i32} - The hamming distance between the two strings or -1 if the
  ;;                  strings are not of equal length.
  ;;
  (func (export "compute") 
    (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32) (result i32)
    ;; following along with Eric

    (local $distance i32)
    (local $i i32)

    (if (i32.ne (local.get $firstLength) (local.get $secondLength))
      (then
        (return (i32.const -1))))

    (loop $loop
      (local.set $distance
        (i32.add
          (local.get $distance)
          (i32.ne
            (i32.load8_u (i32.add (local.get $firstOffset) (local.get $i)))
            (i32.load8_u (i32.add (local.get $secondOffset) (local.get $i))))))
      
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop
        (i32.lt_s
          (local.get $i)
          (local.get $firstLength))))
    (return (local.get $distance))
  )
)
