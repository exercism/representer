;;; bob.el --- Bob exercise (exercism)

;;; Commentary:
;; Simulate a lackadaisical teenager.

;;; Code:

(defun nothing-p (expr)
  "Return t if expr is 'nothing' (all blank only)."
  (let ((nothing "^[[:blank:]]*$")
	(something "[[:alnum:][:punct:]]+"))

    (and (string-match nothing expr)
	 (not (string-match something expr)))))

(defun yell-p (expr)
  "Return t if all words in expr are YELLED (uppercase)."
  (let ((yell "[[:upper:]]\\{2,\\}")
	(noyell "[[:lower:]]\\{2,\\}"))

    (and (string-match yell expr)
	 (not (string-match noyell expr)))))

(defun question-p (expr)
  "Return t if expr is a question (ends with a question mark and )."
  (let ((question "\\?[[:space:]]*$")
	(non_question "\\?.*\n?.*[[:alnum:][:punct:]]+"))

    (and (string-match question expr)
	 (not (string-match non_question expr)))))


(defun response-for (prompt)
  "Returns a response from Bob, a lackadaisical teenager, to the provided prompt."

  ;; Ensure regular expressions below are case-sensitive.
  (let ((case-fold-search nil))

    (pcase prompt
      ;; He says 'Fine. Be that way!' if you address him without actually saying anything.
      ((pred (nothing-p))
       '"Fine. Be that way!")

      ;; He answers 'Calm down, I know what I'm doing!' if you yell a question at him.
      ((and (pred (yell-p))
	    (pred (question-p)))
       '"Calm down, I know what I'm doing!")

      ;; Bob answers "Sure." if you ask him a question, such as "How are you?".
      ((pred (question-p))
       '"Sure.")

      ;; He answers 'Whoa, chill out!' if you YELL AT HIM (in all capitals).
      ((pred (yell-p))
       '"Whoa, chill out!")

      ;; He answers 'Whatever.' to anything else.
      (_ '"Whatever.")

      )))

(provide 'bob)

;;; bob.el ends here
