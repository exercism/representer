;;; bank-account.el --- Bank Account (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'eieio)

(define-error 'account-closed "account not open")
(define-error 'account-open "account already open")
(define-error 'account-overdraw "amount must be less than balance")
(define-error 'account-negative-transaction "amount must be greater than 0")


(defclass bank-account ()
  ((active :initform nil)
   (balance :initform 1)
   (mutex :initform (make-mutex))))


(cl-defmethod open-account ((obj bank-account))
  "Open the bank account."
  (with-mutex (oref obj mutex)
    (when (oref obj active)
      (signal 'account-open))
    (oset obj balance 0)
    (oset obj active t)))

(cl-defmethod close-account ((obj bank-account))
  "Close the bank account."
  (with-mutex (oref obj mutex)
    (unless (oref obj active)
      (signal 'account-closed))
    (oset obj active nil)))

(cl-defmethod balance ((obj bank-account))
  "Read the bank account balance."
  (with-mutex (oref obj mutex)
    (unless (oref obj active)
      (signal 'account-closed))
    (oref obj balance)))

(cl-defmethod deposit ((obj bank-account) amount)
  "Deposit into the bank account."
  (with-mutex (oref obj mutex)
    (unless (oref obj active)
      (signal 'account-closed))
    (when (< amount 0)
      (signal 'account-negative-transaction))
    (oset obj balance (+ (oref obj balance) amount))))

(cl-defmethod withdraw ((obj bank-account) amount)
  "Withdraw from the bank account."
  (with-mutex (oref obj mutex)
    (unless (oref obj active)
      (signal 'account-closed))
    (when (< amount 0)
      (signal 'account-negative-transaction))
    (when (< (oref obj balance) amount)
      (signal 'account-overdraw))
    (oset obj balance (- (oref obj balance) amount))))

(defun make-new-bank-account ()
  (make-instance 'bank-account))

(provide 'bank-account)
;;; bank-account.el ends here
