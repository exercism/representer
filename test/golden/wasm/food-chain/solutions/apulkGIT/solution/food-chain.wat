(module
  (memory (export "mem") 1)

  (data (i32.const 0) "I know an old lady who swallowed a \00")
  (data (i32.const 50) "fly\00")
  (data (i32.const 60) "spider\00")
  (data (i32.const 70) "bird\00")
  (data (i32.const 80) "cat\00")
  (data (i32.const 90) "dog\00")
  (data (i32.const 100) "goat\00")
  (data (i32.const 110) "cow\00")
  (data (i32.const 120) "horse\00")
  (data (i32.const 200) ".\0a\00")
  
  (data (i32.const 250) "It wriggled and jiggled and tickled inside her.\0a\00")
  (data (i32.const 300) "How absurd to swallow a bird!\0a\00")
  (data (i32.const 350) "Imagine that, to swallow a cat!\0a\00")
  (data (i32.const 400) "What a hog, to swallow a dog!\0a\00")
  (data (i32.const 450) "Just opened her throat and swallowed a goat!\0a\00")
  (data (i32.const 500) "I don't know how she swallowed a cow!\0a\00")
  (data (i32.const 550) "She's dead, of course!\0a\00")
  
  (data (i32.const 600) "She swallowed the cow to catch the goat.\0a\00")
  (data (i32.const 700) "She swallowed the goat to catch the dog.\0a\00")
  (data (i32.const 800) "She swallowed the dog to catch the cat.\0a\00")
  (data (i32.const 900) "She swallowed the cat to catch the bird.\0a\00")
  (data (i32.const 1000) "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\0a\00")
  (data (i32.const 1100) "She swallowed the spider to catch the fly.\0a\00")
  (data (i32.const 1200) "I don't know why she swallowed the fly. Perhaps she'll die.\0a\00")

  (func $getlen (param $inputoffset i32) (result i32) 
    (local $char i32)
    (local $i i32)
    (loop $lenloop
        (local.set $char (i32.load8_u (i32.add (local.get $inputoffset) (local.get $i))))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $lenloop (i32.ne (local.get $char) (i32.const 0)))
    )
    (return (i32.sub (local.get $i) (i32.const 1)))
  )

  (func $onecite (param $verse i32) (param $dest i32) (result i32)
    (local $slen i32)
    (local $i i32)

    (local.set $slen (call $getlen (i32.const 0)))
    (memory.copy (local.get $dest) (i32.const 0) (local.get $slen))
    (local.set $dest (i32.add (local.get $dest) (local.get $slen)))
    (local.set $slen (call $getlen (i32.add(i32.const 50) (i32.mul (i32.sub (local.get $verse) (i32.const 1)) (i32.const 10)))))
    (memory.copy (local.get $dest) (i32.add(i32.const 50) (i32.mul (i32.sub (local.get $verse) (i32.const 1)) (i32.const 10))) (local.get $slen))
    (local.set $dest (i32.add (local.get $dest) (local.get $slen)))
    (local.set $slen (call $getlen (i32.const 200)))
    (memory.copy (local.get $dest) (i32.const 200) (local.get $slen))
    (local.set $dest (i32.add (local.get $dest) (local.get $slen)))

    (if (i32.ge_u (local.get $verse) (i32.const 2))
    (then
      (local.set $slen (call $getlen (i32.add(i32.const 250) (i32.mul (i32.sub (local.get $verse) (i32.const 2)) (i32.const 50)))))
      (memory.copy (local.get $dest) (i32.add(i32.const 250) (i32.mul (i32.sub (local.get $verse) (i32.const 2)) (i32.const 50))) (local.get $slen))
      (local.set $dest (i32.add (local.get $dest) (local.get $slen)))
    ))

    (if (i32.le_u (local.get $verse) (i32.const 7))
    (then
      (local.set $i (local.get $verse))
      (loop $verseloop
        (if (i32.le_u (i32.const 1) (local.get $i))
        (then
          (local.set $slen (call $getlen (i32.add(i32.const 600) (i32.mul (i32.sub (i32.const 7) (local.get $i)) (i32.const 100)))))
          (memory.copy (local.get $dest) (i32.add(i32.const 600) (i32.mul (i32.sub (i32.const 7) (local.get $i)) (i32.const 100))) (local.get $slen))
          (local.set $dest (i32.add (local.get $dest) (local.get $slen)))
          (local.set $i (i32.sub (local.get $i) (i32.const 1)))
          (br $verseloop)
        ))
      )
    ))
    (return (local.get $dest))
  )
  ;;
  ;; Lyrics to 'I Know an Old Lady Who Swallowed a Fly'.
  ;;
  ;; @param {i32} startVerse - The initial verse to recite
  ;; @param {i32} endVerse - The final verse to recite
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "recite") (param $startVerse i32) (param $endVerse i32) (result i32 i32)
    (local $i i32)
    (local $dest i32)

    (local.set $dest (i32.const 1536))
    (local.set $i (local.get $startVerse))
    (loop $reciteloop
      (local.set $dest (call $onecite (local.get $i) (local.get $dest)))
      (if $reciteloop (i32.ne (local.get $i) (local.get $endVerse))
      (then
        (i32.store8(local.get $dest) (i32.const 10))
        (local.set $dest (i32.add (local.get $dest) (i32.const 1)))
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $reciteloop (i32.le_s (local.get $i) (local.get $endVerse)))
    )
    (return (i32.const 1536) (i32.sub (local.get $dest) (i32.const 1536)))
  )
)
