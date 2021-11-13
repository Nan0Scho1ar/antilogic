#lang s-exp "antilogic.rkt"

(axiom A #f)
(axiom B #f)
(axiom C #f)
(axiom D #f)

;(def C '(!A ^ B))
;(def !C '(not C))
;; 2 bit counter
(for ([i (in-range 8)])
  (begin
    (show (A -> !B))
    (newline)
    ))
