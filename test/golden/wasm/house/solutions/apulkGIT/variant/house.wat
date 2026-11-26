(module
  (memory (export "mem") 1)

  (data (i32.const 0) "This is the house that Jack built.\0a")
  (data (i32.const 100) "This is the malt ")
  (data (i32.const 200) "This is the rat ")
  (data (i32.const 300) "This is the cat ")
  (data (i32.const 400) "This is the dog ")
  (data (i32.const 500) "This is the cow with the crumpled horn ")
  (data (i32.const 600) "This is the maiden all forlorn ")
  (data (i32.const 700) "This is the man all tattered and torn ")
  (data (i32.const 800) "This is the priest all shaven and shorn ")
  (data (i32.const 900) "This is the rooster that crowed in the morn ")
  (data (i32.const 1000) "This is the farmer sowing his corn ")
  (data (i32.const 1100) "This is the horse and the hound and the horn ")
  
  (data (i32.const 1200) "that belonged to the farmer sowing his corn ")
  (data (i32.const 1300) "that kept the rooster that crowed in the morn ")
  (data (i32.const 1400) "that woke the priest all shaven and shorn ")
  (data (i32.const 1500) "that married the man all tattered and torn ")
  (data (i32.const 1600) "that kissed the maiden all forlorn ")
  (data (i32.const 1700) "that milked the cow with the crumpled horn ")
  (data (i32.const 1800) "that tossed the dog ")
  (data (i32.const 1900) "that worried the cat ")
  (data (i32.const 2000) "that killed the rat ")
  (data (i32.const 2100) "that ate the malt ")
  (data (i32.const 2200) "that lay in the house that Jack built.\0a")

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

  (func $onecite (param $verse i32) (param $d i32) (result i32)
    (local $i i32)
    (local $len i32)
    (local $src i32)
    (local $d2 i32)

    (local.set $src (i32.mul (i32.sub (local.get $verse) (i32.const 1)) (i32.const 100)))
    (local.set $len (call $getlen (local.get $src)))
    (memory.copy (local.get $d) (local.get $src) (local.get $len))
    (local.set $d2 (i32.add (local.get $d) (local.get $len)))
    (local.set $i (local.get $verse))
    (loop $citeloop
      (if (i32.ne (local.get $i) (i32.const 1))
      (then
        (local.set $src (i32.add (i32.const 1200) (i32.mul (i32.sub (i32.const 12) (local.get $i)) (i32.const 100))))
        (local.set $len (call $getlen (local.get $src)))
        (memory.copy (local.get $d2) (local.get $src) (local.get $len))
        (local.set $d2 (i32.add (local.get $d2) (local.get $len)))
        (local.set $i (i32.sub (local.get $i) (i32.const 1)))
        (br $citeloop)
      ))
    )
    (return (i32.sub (local.get $d2) (local.get $d)))
  )
  ;;
  ;; Lyrics to 'This is the House that Jack Built'.
  ;;
  ;; @param {i32} startVerse - The initial verse to recite
  ;; @param {i32} endVerse - The final verse to recite
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "recite") (param $startVerse i32) (param $endVerse i32) (result i32 i32)
    (local $i i32)
    (local $d i32)
    (local.set $i (local.get $startVerse))
    (local.set $d (i32.const 3072))
    (loop $reciteloop
      (local.set $d (i32.add (local.get $d) (call $onecite (local.get $i) (local.get $d))))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $reciteloop (i32.ne (local.get $i) (i32.mul (local.get $endVerse) (i32.const 1))))
    )
    (return (i32.const 3072) (i32.sub (local.get $d) (i32.const 3072)))
  )
)
