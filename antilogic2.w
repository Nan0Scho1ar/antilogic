#!/bin/clisp

(defmacro get-val (x)
  `(setf ,x (not ,x)))

(defun printvals (a b c d)
  (format t "~s ~s ~s ~s~%" a b c d))

(let (a_ b_ c_ d_)
  (symbol-macrolet ((A (get-val a_))
                    (B (and (get-val b_) A))
                    (C (and (get-val c_) B))
                    (D (and (get-val d_) C)))
    ;; do stuff with A B C D
    (loop for i from 0 to 20 do (printvals A B C D))))
