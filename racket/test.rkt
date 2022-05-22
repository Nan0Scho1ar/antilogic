#lang s-exp "antilogic.rkt"
(require racket/bool)

(axiom A #f)
(axiom B #f)
(axiom C #f)
(axiom D #f)
(axiom E #f)
(axiom F #f)
(axiom G #f)
(axiom H #f)

;; (for ([i (in-range 4)])
;;   (begin
;;     (show (A ^ B))
;;     (show ((A ^ B) v B))
;;     (newline)))



;; (^ #f #t)
;; (^ A A)
;; (^ A (not A))



;; ;; ;; 2 bit counter
;; (for ([i (in-range 32)])
;;   (begin
;;     (implies (implies A (or B A)) A)
;;     (show B)
;;     (show A)
;;     (newline)))

(for ([i (in-range 256)])
  (begin
    (or A (or B (or C (or D (or E (or F (or G H)))))))
    (show peekH)
    (show peekG)
    (show peekF)
    (show peekE)
    (show peekD)
    (show peekC)
    (show peekB)
    (show peekA)
    (newline)))

(axiom VAL #t)
(axiom LATCH #t)
(axiom CHANGE-VAL '(and (LATCH ^ !LATCH) VAL))
