#lang racket

(provide calculate-frequencies)

(define (calculate-frequencies texts)
  (define frequency-map (make-hash))
  (define frequency-mutex (make-semaphore 1))  ;; Mutex for updating the shared frequency map
  
  ;; Helper function to merge local frequency maps into the shared map
  (define (merge-local-frequencies local-map)
    (semaphore-wait frequency-mutex)  ;; Acquire the mutex
    (hash-for-each local-map (lambda (char count)
                               (hash-update! frequency-map char (curry + count) 0)))
    (semaphore-post frequency-mutex))  ;; Release the mutex

  ;; Helper function to process a single text and return a local frequency map
  (define (process-text text)
    (define local-map (make-hash))
    (for ([char (string->list (string-downcase text))])
      (when (char-alphabetic? char)
        (hash-update! local-map char add1 0)))
    local-map)

  ;; Process each text concurrently, collecting local maps
  (define threads
    (for/list ([text texts])
      (thread (λ () (merge-local-frequencies (process-text text))))))
  
  ;; Wait for all threads to finish
  (for ([t threads]) (thread-wait t))
  
  frequency-map)
