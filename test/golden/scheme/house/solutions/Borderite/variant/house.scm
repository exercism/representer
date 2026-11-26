(import (rnrs))
(use-modules (ice-9 streams))

(define objects #(""
                  "the house that Jack built."
                  "the malt that lay in"
                  "the rat that ate"
                  "the cat that killed"
                  "the dog that worried"
                  "the cow with the crumpled horn that tossed"
                  "the maiden all forlorn that milked"
                  "the man all tattered and torn that kissed"
                  "the priest all shaven and shorn that married"
                  "the rooster that crowed in the morn that woke"
                  "the farmer sowing his corn that kept"
                  "the horse and the hound and the horn that belonged to"))

(define (recite-verse i port)
  (format port "~a" (vector-ref objects i))
  (when (> i 1)
      (put-char port #\Space)
      (recite-verse (- i 1) port)))

(define (recite start-verse end-verse)
  (call-with-output-string
   (lambda (port)
     (let loop ((i start-verse))
       (format port "This is ")
       (if (>= i end-verse)
           (recite-verse end-verse port)
           (begin
             (recite-verse i port)
             (put-char port #\newline)
             (loop (+ i 2))))))))
