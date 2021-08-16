#!/bin/clisp

(defun get-val(x)
  (set x (not (symbol-value x)))
  (return-from get-val (symbol-value x)))


(setq a_private 'nil)
(define-symbol-macro A (get-val 'a_private))

(format t "A -> ~d~%" A)
(format t "A -> ~d~%" A)
(format t "A -> ~d~%" A)
(format t "A -> ~d~%" A)

(format t "~%Logic:~%")
(format t "A = A -> ~d~%" (equalp A A))
(format t "A != !A -> ~d~%" (not (equalp A (not A))))
(format t "!A v A -> ~d~%" (or (not A) A))

(format t "~%Antilogic:~%")
(format t "A != A -> ~d~%" (not (equalp A A)))
(format t "A = !A -> ~d~%" (equalp A (not A)))
(format t "!A ^ A -> ~d~%" (and A (not A)))

; A = A
; A != !A
; !A v A

; A != A
; A = !A
; A ^ !A
