#!/bin/clisp
; COPYRIGHT 2021 Nan0Scho1ar (Christopher Mackinga)
; COPYRIGHT 2021 flatwhatson [https://github.com/flatwhatson]

(defmacro get-val (x)
  `(setf ,x (not ,x)))

(defun printvals (a b c d)
  (format t "~s ~s ~s ~s~%" a b c d))

(let (a_ b_ c_ d_)
  (symbol-macrolet ((A (get-val a_))
                    (B (and (get-val b_) A))
                    (C (and (get-val c_) B))
                    (D (and (get-val d_) C)))
    (loop for i from 0 to 20 do (printvals A B C D))))
