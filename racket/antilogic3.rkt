#lang racket
; COPYRIGHT 2021 Nan0Scho1ar (Christopher Mackinga)


(require (rename-in racket/base (and ^)))
(require (rename-in racket/base (or v)))
(require (rename-in racket/base (not !)))


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


;; (require (for-syntax racket/base syntax/transformer))
;; (define-syntax-rule (def name val)
;;   (begin
;;     (define tmp val)
;;     (define-syntax name
;;       (make-variable-like-transformer
;;        #'(begin0 tmp (set! tmp (not tmp)))))))


;; (require (for-syntax racket/base racket/syntax syntax/transformer))
;; (define-syntax (def stx)
;;   (syntax-case stx ()
;;     [(def name val)
;;      (with-syntax ([name_ (format-id #'name "~a_" #'name)])
;;        #'(begin
;;            (define name_ val)
;;            (define-syntax name
;;              (make-variable-like-transformer
;;               #'(begin0 name_ (set! name_ (not name_)))))))]))

(def 'a #f)
;(def 'b #f)
