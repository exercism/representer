(defmodule line-up
  (export (format 2)))

(defun format (name line)
  (cond 
     ((and (== 1 (rem line 10)) (not (== 11 (rem line 100))) ) 
      (lists:flatten (io_lib:format "~s, you are the ~pst customer we serve today. Thank you!" (list name line))) ) 
     ((and (== 2 (rem line 10)) (not (== 12 (rem line 100))) ) 
      (lists:flatten (io_lib:format "~s, you are the ~pnd customer we serve today. Thank you!" (list name line))) ) 
     ((and (== 3 (rem line 10)) (not (== 13 (rem line 100))) ) 
      (lists:flatten (io_lib:format "~s, you are the ~prd customer we serve today. Thank you!" (list name line))) ) 
     ('true 
      (lists:flatten (io_lib:format "~s, you are the ~pth customer we serve today. Thank you!" (list name line))) ) 
    )
  )