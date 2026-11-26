(module
  (memory (export "mem") 1)

  (global $unequal i32 (i32.const 0))
  (global $sublist i32 (i32.const 1))
  (global $equal i32 (i32.const 2))
  (global $superlist i32 (i32.const 3))

  (func $str_cmp
    (param $a i32)
    (param $b i32)
    (param $len i32)
    (result i32)
    (local $i i32)
    (block $out
      (loop $loop
        (br_if $out
          (i32.ge_u
            (local.get $i)
            (local.get $len)))
        (if
          (i32.ne
            (i32.load8_u
              (i32.add
                (local.get $a)
                (local.get $i)))
            (i32.load8_u
              (i32.add
                (local.get $b)
                (local.get $i))))
          (then
            (return
              (i32.const 0))))
        (local.set $i
          (i32.add
            (local.get $i)
            (i32.const 1)))
        (br $loop)))
    (i32.const 1))

  (func $str_str
    (param $a i32)
    (param $alen i32)
    (param $b i32)
    (param $blen i32)
    (result i32)
    (local $i i32)
    (block $out
      (loop $loop
        (br_if $out
          (i32.gt_u
            (i32.add
              (local.get $i)
              (local.get $blen))
            (local.get $alen)))
        (if
          (call $str_cmp
            (i32.add
              (local.get $a)
              (local.get $i))
            (local.get $b)
            (local.get $blen))
          (then
            (return
              (local.get $i))))
        (local.set $i
          (i32.add
            (local.get $i)
            (i32.const 1)))
        (br $loop)))
    (i32.const -1))

  ;;
  ;; Compare two lists.
  ;;
  ;; @param {i32} $firstOffset - offset of the first list in linear memory
  ;; @param {i32} $firstLength - length of the first list in linear memory
  ;; @param {i32} $secondOffset - offset of the second list in linear memory
  ;; @param {i32} $secondLength - length of the second list in linear memory
  ;;
  ;; @returns {i32} - $unequal, $sublist, $equal or $superlist
  ;;
  (func (export "compare") (param $firstOffset i32) (param $firstLength i32)
    (param $secondOffset i32) (param $secondLength i32) (result i32)
    (if
      (i32.eq
        (local.get $firstLength)
        (local.get $secondLength))
      (then
        (return
          (select
            (global.get $equal)
            (global.get $unequal)
            (call $str_cmp
                (local.get $firstOffset)
                (local.get $secondOffset)
                (local.get $firstLength))))))
    (if
      (i32.ge_s
        (call $str_str
          (local.get $firstOffset)
          (local.get $firstLength)
          (local.get $secondOffset)
          (local.get $secondLength))
        (i32.const 0))
      (then
        (return
          (global.get $superlist)))
      (else
        (if
          (i32.ge_s
            (call $str_str
              (local.get $secondOffset)
              (local.get $secondLength)
              (local.get $firstOffset)
              (local.get $firstLength))
            (i32.const 0))
          (then
            (return
              (global.get $sublist))))))
    (global.get $unequal))
)
