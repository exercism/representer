(defmodule isogram
  (export (isogram? 2)))

(defun isogram? (phrase)
  (let* ((lowered (string:to_lower phrase))
         (chars (re:replace lowered
                             "[^a-z]"
                            ""
                            '(#(return list) global)))
         (uniques (lists:usort chars)))
    (=:= (length chars) (length uniques))))
