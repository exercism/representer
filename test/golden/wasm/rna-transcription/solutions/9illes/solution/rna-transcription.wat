(module
  (memory (export "mem") 1)
  (func (export "toRna") (param $offset i32) (param $length i32) (result i32 i32) (local $cursor i32)

    (i32.eq
      (i32.const 0)
      (local.get $length))
    (if(then
      (return (local.get $offset) (local.get $length))))

    ;; loop on each nucleotide
    (loop $char_loop
      (block $break

        ;; load memory offset+cursor for store8
        (i32.add
            (local.get $offset)
            (local.get $cursor))

        ;; get transcribed nucleotide
        (call $transcribe
          (i32.load8_s
          (i32.add
            (local.get $offset)
            (local.get $cursor))))

        ;; replace by the RNA transcription
        (i32.store8)

        ;; inc string cursor
        (i32.add
          (i32.const 1)
          (local.get $cursor))
        (local.tee $cursor)

        ;; all nucleotides computed ?
        (local.get $length)
        (i32.eq)
        br_if $break

        br $char_loop
    ))

    (return (local.get $offset) (local.get $length))
  )

  (func $transcribe (param $nucleotide i32) (result i32)
    (i32.eq
      (local.get $nucleotide)
      (i32.const 0x47))         ;; G
    (if(then
      (return (i32.const 0x43)) ;; C
    ))

    (i32.eq
      (local.get $nucleotide)
      (i32.const 0x43))         ;; C
    (if(then
      (return (i32.const 0x47)) ;; G
    ))

    (i32.eq
      (local.get $nucleotide)
      (i32.const 0x54))         ;; T
    (if(then
      (return (i32.const 0x41)) ;; A
    ))

    (i32.eq
      (local.get $nucleotide)
      (i32.const 0x41))         ;; A
    (if(then
      (return (i32.const 0x55)) ;; U
    ))

    (return (i32.const -1))
  )
)
