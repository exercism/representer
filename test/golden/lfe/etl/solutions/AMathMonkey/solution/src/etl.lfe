(defmodule etl
  (export (transform 1)))

;; This exercise seems flawed and needs an update to its test cases to align with other languages.
;; Passing and expecting lists instead of maps as input/output values is suboptimal,
;; and multiple test cases are invalid and don't appear in other languages' implementations
;; because they violate static typing rules and the problem description.

(defun transform (old)
  (maps:to_list
    (lists:foldl 
      ;; Test "transform-multiple-keys-from-one-value" is invalid as per the problem spec.
      ;; If the same word appears with two different scores, concatenate the scores together?
      ;; This makes no sense and would crash if this happened in a test case where scores were (rightfully) numbers.
      (lambda (map acc) (maps:merge_with (lambda (_ score1 score2) (++ score1 score2)) acc map))
      (maps:new)
      (lists:map (match-lambda (((tuple score words))
        (maps:from_list
          (lc ((<- word words)) 
            ;; Multiple tests provide numbers (which cannot be converted to lowercase) as words. 
            ;; That's a spec violation that requires this dynamic type check as a workaround.
            (tuple (if (is_list word) (string:lowercase word) word) score)))))
        old))))
