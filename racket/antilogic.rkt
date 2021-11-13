#lang racket/base
;; https://github.com/dyoo/infix-syntax-example/


(require (for-syntax racket/base
                     syntax/boundmap))
(require racket/bool)

(require syntax/parse/define
         (for-syntax racket/base racket/syntax syntax/transformer))

(provide (except-out (all-from-out racket/base) #%app)
         (rename-out [my-app #%app])

         define-infix-transformer
         +
         :=
         declare-infix
         *)


(begin-for-syntax
  ;; We need some way of communicating that some thing
  ;; should be treated as an infix operator.
  ;; I'll use a hashtable here that exists at compile time.
  (define auxiliary-infix-transformers
    (make-free-identifier-mapping)))


;; This defines a protocol for infix syntax that works on top of
;; the function application macro.
;; If we see something like
;;
;;     (lhs op rhs)
;;
;; where op's syntactic value is an infix operator, then we let
;; the infix syntax macro take over.
(define-syntax (my-app stx)
  (syntax-case stx ()
    ;; If the operator has been labeled as infix, by being in
    ;; auxiliary-infix-transformers, then the infix protocol activates:
    [(_ lhs op rhs)
     (and (identifier? #'op)
          (free-identifier-mapping-get auxiliary-infix-transformers
                                       #'op
                                       (lambda () #f)))
     ((free-identifier-mapping-get auxiliary-infix-transformers #'op)
      (syntax/loc stx (lhs op rhs)))]

    ;; Otherwise, just default to regular function application.
    [(_ args ...)
     (syntax/loc stx
       (#%app args ...))]))



;; The following registers + so that it can be used in infix
;; position.  The code is a bit ugly; I may want to provide an abstraction
;; to make it nicer to express.
(begin-for-syntax
  (free-identifier-mapping-put!
   auxiliary-infix-transformers
   #'+
   (lambda (stx)
     (syntax-case stx ()
       [(lhs _ rhs)
        (syntax/loc stx (+ lhs rhs))]))))


;; Ok, let's make the definition of infix operators a little nicer.
;; We'll provide a define-infix form that will do pretty much what
;; we did for the + binding above.
(define-syntax (define-infix-transformer stx)
  (syntax-case stx ()
    [(_ id transformer)
     (syntax/loc stx
       (begin-for-syntax
         (free-identifier-mapping-put!
          auxiliary-infix-transformers
          #'id
          transformer)))]))


;; Let's define := using define-infix-transformer.
(define-infix-transformer :=
  (lambda (stx)
    (syntax-case stx ()
      [(lhs _ rhs)
       (syntax/loc stx (set! lhs rhs))])))


;; := doesn't exist in the original language, so if it's used
;; in non-infix position, it'll give a funky error message.
;; We want a good error message if := is being used in non-infix position,
;; so let's create a binding here to do it:
(define-syntax (:= stx)
  (raise-syntax-error #f "Can't be used in non-infix position" stx))


;; The common thing to do seems to be to rearrange the infix operator
;; so it's at the head.  Let's make one more macro to make that convenient.
(define-syntax (declare-infix stx)
  (syntax-case stx ()
    [(_ id)
     (syntax/loc stx
       (define-infix-transformer id
         (lambda (stx2)
           (syntax-case stx2 ()
             [(lhs op rhs)
              (syntax/loc stx2 (op lhs rhs))]))))]))

;; COPYRIGHT 2021 Nan0Scho1ar (Christopher Mackinga)
;
; TODO nice not implementation

;; remap and/or
;; (require (rename-in racket/base (and ^)))
;; (require (rename-in racket/base (or v)))
;; (require (rename-in racket/bool (implies ->)))

;; Implement and without short circuit
(define (^ a b)
  (begin
    (define a_ a)
    (define b_ b)
    (and a_ b_)))

;; Implement or without short circuit
(define (v a b)
  (begin
    (define a_ a)
    (define b_ b)
    (or a_ b_)))


;; Implement implies without short circuit
(define (-> a b)
  (begin
    (define a_ a)
    (define b_ b)
    (implies a_ b_)))

;; allow infix and/or
(declare-infix ^)
(declare-infix v)
(declare-infix ->)

(provide ^)
(provide v)
(provide ->)

;; Macro to create an "antilogic axiom"
(define-syntax-parse-rule (axiom name:id val:expr)
  #:with inverse (format-id #'name "!~a" #'name)
  #:with peek (format-id #'name "peek~a" #'name)
  (begin
    (define tmp val)
    (define-syntax peek
      (make-variable-like-transformer
        #'(begin0 tmp (set! tmp tmp))))
    (define-syntax inverse
      (make-variable-like-transformer
        #'(begin0 (not tmp) (set! tmp (not tmp)))))
    (define-syntax name
      (make-variable-like-transformer
        #'(begin0 tmp (set! tmp (not tmp)))))))

(provide axiom)

(define-syntax-parse-rule (def name:id val:expr)
    (define-syntax name
      (make-variable-like-transformer
        (eval val))))

(provide def)

;; Print bool as 1 or zero
(define (show expr)
    (if expr
        (display 1)
        (display 0)))
(provide show)

;; Get current value of axiom without disturbing it (for debugging)
;; (define (peek axiom)
;;   (begin (eval axiom)
;;          (not (eval axiom))))

;; (provide peek)

;; (define (loop n lst)
;;   (for ([i (in-range n)])
;;     (eval lst)))
;; (provide loop)

;; (require (rename-in racket/base (and and)))
;; (require (rename-in racket/base (or or)))
;; (require (rename-in racket/base (not not)))

;; (define-namespace-anchor anc)
;; (define ns (namespace-anchor->namespace anc))

;; (define-syntax-rule (get-val x)
;;   (begin (set! x (not x)) x))

;; (define-syntax-rule (def name val)
;;   (begin
;;     (define name_ (string-append (symbol->string name) "_"))
;;     (eval `(define ,(string->symbol name_) ,val)
;;           ns)
;;     (eval `(define-syntax
;;              (,name stx)
;;              #'(get-val ,(string->symbol name_)))
;;           ns)))

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
