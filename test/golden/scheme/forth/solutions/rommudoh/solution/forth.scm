;; helper for "map" type (for environment)
(define key car)
(define value cdr)

(define (fetch k map)
  "find the value for given key in map"
  (cond
   ;; not found
   ((null? map) (error (format #f "unknown word ~a" k)))
   ;; found
   ((string-ci= (key (car map)) k) (value (car map)))
   ;; recurse
   (else (fetch k (cdr map)))))

(define (insert k v map)
  "set value of given key in map, replacing existing value"
  (cons (cons (string-downcase k) v)
        (filter (lambda (e) (not (string-ci= (key e) k)))
                map)))

;; helper functions for "stack" access
(define (push val stack) (cons val stack))
(define head car)
(define pop cdr)

(define (apply-fun f)
  "apply a function to top two elements, removing them and pushing the result"
  (lambda (stack)
    (let ((result (f (head (pop stack)) (head stack))))
      (push result (pop (pop stack))))))
(define (dup stack)
  "duplicate top element on stack"
  (push (head stack) stack))
(define (swap stack)
  "swap first and second element of stack"
  (let ((first (head stack))
        (second (head (pop stack))))
    (push second (push first (pop (pop stack))))))
(define (over stack)
  "pushes second element of stack onto the stack"
  (push (head (pop stack)) stack))

(define initial-env
  ;; pre-defined words in the environment
  ;; each entry has a function or list of functions to be called
  `(("+" . ,(apply-fun +))
    ("-" . ,(apply-fun -))
    ("*" . ,(apply-fun *))
    ("/" . ,(apply-fun quotient))
    ("dup" . ,dup)
    ("drop" . ,pop)
    ("swap" . ,swap)
    ("over" . ,over)
    ;; add ; as word for identity to make it easier to parse
    (";" . ,identity)))

(define (resolve-words lst env)
  "replace all strings in lst with either value from env or number"
  (map (lambda (e)
         (cond
          ((string->number e))
          ((list? e) (resolve-words e env))
          (else (fetch e env))))
       lst))

(define (definition? lst)
  "return true if lst is a definition (beginning with a colon)"
  (equal? (car lst) ":"))

(define (eval-definition lst env)
  "evaluate a word definition to the environment"
  (let ((name (cadr lst))
        (value (resolve-words (cddr lst) env)))
    ;; don't allow redefining numbers
    (if (string->number name)
        (error "cannot redefine numbers")
        (insert name value env))))

(define (apply-list flst stack)
  "apply a list of instructions to the stack"
  (cond
   ;; nothing left to do -> return stack
   ((null? flst) stack)
   ;; numbers are simply pushed to the stack
   ((number? (car flst))
    (apply-list (cdr flst)
                (push (car flst) stack)))
   ;; lists are applied recursively
   ((list? (car flst))
    (apply-list (cdr flst)
                (apply-list (car flst) stack)))
   ;; functions are applied to the stack
   (else
    (apply-list (cdr flst)
                ((car flst) stack)))))

(define (eval-instruction instructions env stack)
  "evaluate list of instructions with given env and stack"
  (let loop ((instructions (resolve-words instructions env))
             (stack stack))
    (cond
     ;; no instructions left = finished
     ((null? instructions) stack)
     ;; procedure = call it
     ((procedure? (car instructions))
      (loop (cdr instructions)
            ((car instructions) stack)))
     ;; list of procedures = call all of them
     ((list? (car instructions))
      (loop (cdr instructions)
            (apply-list (car instructions) stack)))
     ;; else push it to the stack (it's a number)
     (else
      (loop (cdr instructions)
            (push (car instructions) stack))))))

(define (forth program)
  "evaluate given forth program, which is a list of strings,
   with last string being instructions and strings before it are definitions"
  (let loop ((env initial-env)
             (stack '())
             (instructions
              ;; split the input strings at whitespaces
              (map (lambda (s) (string-split s char-whitespace?))
                   program)))
    (cond
     ;; next instruction is definition -> insert to environment
     ((definition? (car instructions))
      (loop (eval-definition (car instructions) env)
            stack
            (cdr instructions)))
     ;; instruction is an empty list -> error
     ((null? (car instructions))
      (error "empty instructions"))
     ;; apply instructions to stack
     (else
      ;; no need to recurse afterwards, since only one instruction per program
      (eval-instruction (car instructions) env stack)))))
