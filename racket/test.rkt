#lang s-exp "antilogic.rkt"

(axiom A #f)
(axiom B #f)
(axiom C #f)

(for ([i (in-range 4)])
  (begin
    (show (A ^ B))
    (show ((A ^ B) v B))
    (newline)))



;; (^ #f #t)
;; (^ A A)
;; (^ A (not A))



;; ;; 2 bit counter
;; (for ([i (in-range 32)])
;;   (begin
;;     ((A -> (B v A)) -> A)
;;     (show B)
;;     (show A)
;;     (newline)))
