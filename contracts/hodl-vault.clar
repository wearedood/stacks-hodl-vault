;; Contract: hodl-vault

(define-constant ERR-TOO-EARLY (err u100))
(define-constant ERR-NO-FUNDS (err u101))
(define-constant VAULT-ADDRESS 'SP1GVG84HRYCBYEW59M0S4XGQF8TTVXRF8XNXGBMH.hodl-vault)

(define-map vault principal { amount: uint, unlock-height: uint })

(define-public (lock (amount uint) (duration uint))
  (let ((unlock-at (+ burn-block-height duration)))
    (begin
      (try! (stx-transfer? amount tx-sender VAULT-ADDRESS))
      (map-set vault tx-sender { amount: amount, unlock-height: unlock-at })
      (ok unlock-at)
    )
  )
)

(define-public (withdraw)
  ;; 1. Outer 'let' loads the deposit securely
  (let ((user tx-sender)
        (deposit (unwrap! (map-get? vault tx-sender) ERR-NO-FUNDS)))
    
    ;; 2. Nested 'let' ensures 'amount' only evaluates AFTER 'deposit' is ready
    (let ((amount (get amount deposit))
          (unlock-at (get unlock-height deposit)))
      (begin
        (asserts! (>= burn-block-height unlock-at) ERR-TOO-EARLY)
        (map-delete vault user)
        
        ;; 3. Clarity 4 'as-contract?' with strict STX allowance
        (try! (as-contract? ((with-stx amount)) 
          (unwrap-panic (stx-transfer? amount tx-sender user))
        ))
        
        (ok amount)
      )
    )
  )
)

(define-read-only (get-deposit (user principal))
  (map-get? vault user)
)
