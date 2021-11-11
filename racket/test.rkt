#lang s-exp "antilogic.rkt"

(axiom A #f)

(def B '!A)

;(def C '(!A ^ B))
;(def !C '(not C))
;; 2 bit counter
(for ([i (in-range 32)])
  (begin
    (show !A)
    (newline)))
