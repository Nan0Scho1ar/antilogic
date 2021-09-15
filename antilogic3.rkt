#lang racket/gui
; COPYRIGHT 2021 Nan0Scho1ar (Christopher Mackinga)

(define-namespace-anchor anc)
(define ns (namespace-anchor->namespace anc))

(define-syntax-rule (get-val x)
  (begin (set! x (not x)) x))

(define-syntax-rule (def name val)
  (begin
    (define name_ (string-append (symbol->string name) "_"))
    (eval `(define ,(string->symbol name_) ,val)
          ns)
    (eval `(define-syntax
             (,name stx)
             #'(get-val ,(string->symbol name_)))
          ns)))

(def 'a #f)
(def 'b #f)
(def 'c (and a b))
