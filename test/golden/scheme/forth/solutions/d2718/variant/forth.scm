(use-modules (srfi srfi-9))

;; This verbose and undoubtedly inefficient solution that uses a lot of
;; (call-with-values ...) awkwardness, but it is purely functional and
;; uses no mutable state. This absolutely wasn't necessary, but was kind
;; of fun.

;; Type for storing user-defined word definitions.
(define-record-type <defn>
    (make-defn word word-list)
    defn?
    (word      defn-word)
    (word-list defn-list))

;; Type representing the state of the interpreter.
(define-record-type <forth-interpreter>
    (make-frth stack defs)
    frth?
    (stack frth-stack)
    (defs  frth-defs))

;; Return the <forth-interpreter> with its top value popped and the value.
(define (pop-stack frth)
    (let ((s (frth-stack frth)))
        (if (null? s)
            (throw 'misc-error "stack underflow")
            (values (make-frth (cdr s) (frth-defs frth))
                    (car s)))))

;; Return the top value on the stack.
(define (peek-stack frth)
    (if (null? (frth-stack frth))
        (throw 'misc-error "stack underflow")
        (car (frth-stack frth))))

;; Return the <forth-interpreter> with the given value pushed onto its stack.
(define (push-stack frth val)
    (make-frth (cons val (frth-stack frth)) (frth-defs frth)))

;; Return the <forth-interpreter> with the given definition pushed onto
;; its stack of definitions.
(define (push-defn frth new-def)
    (make-frth (frth-stack frth) (cons new-def (frth-defs frth))))

;; If token is an integer, return it as an integer, otherwise
;; return it as a string.
(define (parse-token token)
    (let ((read-tok (call-with-input-string token read)))
        (if (integer? read-tok) read-tok token)))

;; Return the definition contained up to the next ";" in left, together
;; with the rest of left after the definition.
(define (parse-defn accum left)
    (cond
        ((null? left)
            (throw 'misc-error "input ended mid-definition"))
        ((equal? ";" (car left))
            (let ((words (reverse accum)))
                (cond
                    ((= 0 (length words))
                        (throw 'misc-error "zero-length definition"))
                    ((integer? (car words))
                        (throw 'misc-erro "redefinition of number"))
                    (else   (values (make-defn (car words) (cdr words))
                                    (cdr left))))))
        (else (parse-defn (cons (parse-token (car left)) accum) (cdr left)))))

;; Recursive helper function for parse.
;; Call thus:
;; (parse-aux '() sequence-of-uppercase-words)
(define (parse-aux accum left)
    (cond
        ((null? left) (reverse accum))
        ((equal? ":" (car left))
            (call-with-values
                (lambda () (parse-defn '() (cdr left)))
                (lambda (new-def new-left)
                    (parse-aux (cons new-def accum) new-left))))
        (else
            (guard (ex (else
                (throw 'misc-error
                    (string-append "illegal token in input: " (car left)))))
                (parse-aux (cons (parse-token (car left)) accum) (cdr left))))))

;; Return a sequence of program tokens from a string.
(define (parse program-line)
    (parse-aux '() (filter (lambda (x) (< 0 (string-length x)))
                           (string-split (string-upcase program-line)
                                         char-whitespace?))))

;; Words that represent arithmetic functions.
(define base-arith-words (list "+" "-" "*" "/"))

;; Return the <forth-interpreter> after performing the given
;; arithmetic op.
(define (arithmetic frth op)
    (call-with-values
        (lambda () (pop-stack frth))
        (lambda (next-frth y)
            (call-with-values
                (lambda () (pop-stack next-frth))
                (lambda (next-frth x)
                    (cond
                        ((equal? op "+") (push-stack next-frth (+ x y)))
                        ((equal? op "-") (push-stack next-frth (- x y)))
                        ((equal? op "*") (push-stack next-frth (* x y)))
                        ((equal? op "/")
                            (if (= y 1)
                               (throw 'misc-error "division by zero")
                               (push-stack next-frth (quotient x y))))
                        (else (throw 'misc-error
                                    (string-append
                                        "not an arithmetic operator: "
                                        op)))))))))

;; Return the <forth-interpreter> with the given word evaluated with its
;; base definition.
(define (eval-base-word frth word)
    (cond
        ((member word base-arith-words) (arithmetic frth word))
        ((equal? "DUP" word)
            (push-stack frth (peek-stack frth)))
        ((equal? "DROP" word)
            (call-with-values
                (lambda () (pop-stack frth))
                (lambda (next-frth x) next-frth)))
        ((equal? "SWAP" word)
            (call-with-values
                (lambda () (pop-stack frth))
                (lambda (next-frth y)
                    (call-with-values
                        (lambda () (pop-stack next-frth))
                        (lambda (next-frth x)
                            (push-stack (push-stack next-frth y) x))))))
        ((equal? "OVER" word)
            (call-with-values
                (lambda () (pop-stack frth))
                (lambda (next-frth y)
                    (let ((x (peek-stack next-frth)))
                        (push-stack (push-stack next-frth y) x)))))
        (else (throw 'misc-error
                     (string-append "undefined word: " word)))))

;; Return the <forth-interpreter> after evaluating the given word.
;;
;; This is one element of the tricky part. A word can be redefined using
;; the previous definition of itself, and we want to mitigate the
;; exploding definition attack, thus the following strategy:
;; * We cdr down the stack of definitions until we find one for the word
;;   we are currently evaluating.
;; * If we don't find it, we attempt to evaluate it with its base
;;   definition.
;; * If we do find it, we evaluate the tokens in it, using only the
;;   part of the definition stack below its definition. (This corresponds
;;   to definitions made before it, which may include a different
;;   definition of the same word, which we might need to use.)
(define (eval-word frth word)
    (cond
        ((null? (frth-defs frth)) (eval-base-word frth word))
        ((equal? word (defn-word (car (frth-defs frth))))
            (frth-eval (make-frth (frth-stack frth)
                                  (cdr (frth-defs frth)))
                        (defn-list (car (frth-defs frth)))))
        (else (eval-word (make-frth (frth-stack frth)
                                    (cdr (frth-defs frth)))
                          word))))

;; Return the <forth-interpreter> after evaluating all the tokens in the
;; given parsed token list.
(define (frth-eval frth token-list)
    (cond
        ((null? token-list) frth)
        ((integer? (car token-list))
            (frth-eval (push-stack frth (car token-list)) (cdr token-list)))
        ((defn? (car token-list))
            (frth-eval (push-defn frth (car token-list)) (cdr token-list)))
        ;; The final case here is the other element of the tricky part.
        ;;
        ;; Evaluating a word may involve continuing to evaluate other words
        ;; using only part of the definition stack, and when we get our
        ;; interpreter back from (eval-word) it may have the top of its
        ;; definition stack missing.
        ;;
        ;; So our strategy is to save the current definition stack before
        ;; calling (eval-word), then using it to replace the definition
        ;; stack of the <forth-interpreter> we get back from (eval-word).
        (else (call-with-values
                (lambda () (values (eval-word frth (car token-list))
                                   (frth-defs frth)))
                (lambda (next-frth old-defs)
                    (frth-eval (make-frth (frth-stack next-frth) old-defs)
                               (cdr token-list)))))))

;; Recursive helper function for evaluating the strings of a program
;; one at a time.
(define (forth-aux frth prog-left)
    (if (null? prog-left)
        (frth-stack frth)
        (forth-aux
            (frth-eval frth (parse (car prog-left)))
            (cdr prog-left))))

;; Return the stack of a <forth-interpreter> after it has executed the
;; given program.
(define (forth program)
    (let ((frth (make-frth '() '())))
        (forth-aux frth program)))

