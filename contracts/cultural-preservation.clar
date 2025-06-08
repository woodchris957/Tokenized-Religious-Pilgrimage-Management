;; Cultural Preservation Contract
;; Preserves pilgrimage cultural significance and traditions

(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_NOT_FOUND (err u501))
(define-constant ERR_ALREADY_EXISTS (err u502))

;; Data structures
(define-map cultural-sites
  { site-id: uint }
  {
    name: (string-ascii 100),
    location: (string-ascii 100),
    historical-significance: (string-ascii 500),
    preservation-status: (string-ascii 50),
    guardian: principal,
    visitor-guidelines: (string-ascii 300),
    registered-at: uint
  }
)

(define-map cultural-practices
  { practice-id: uint }
  {
    name: (string-ascii 100),
    description: (string-ascii 500),
    origin-site: uint,
    preservation-priority: (string-ascii 20),
    documented-by: principal,
    documentation-date: uint
  }
)

(define-map preservation-contributions
  { contribution-id: uint }
  {
    contributor: principal,
    site-id: uint,
    contribution-type: (string-ascii 50),
    amount: uint,
    description: (string-ascii 200),
    contributed-at: uint
  }
)

(define-data-var next-site-id uint u1)
(define-data-var next-practice-id uint u1)
(define-data-var next-contribution-id uint u1)

;; Public functions
(define-public (register-cultural-site
  (name (string-ascii 100))
  (location (string-ascii 100))
  (historical-significance (string-ascii 500))
  (visitor-guidelines (string-ascii 300))
)
  (let ((site-id (var-get next-site-id)))
    (map-set cultural-sites
      { site-id: site-id }
      {
        name: name,
        location: location,
        historical-significance: historical-significance,
        preservation-status: "active",
        guardian: tx-sender,
        visitor-guidelines: visitor-guidelines,
        registered-at: block-height
      }
    )
    (var-set next-site-id (+ site-id u1))
    (ok site-id)
  )
)

(define-public (document-cultural-practice
  (name (string-ascii 100))
  (description (string-ascii 500))
  (origin-site uint)
  (preservation-priority (string-ascii 20))
)
  (let ((practice-id (var-get next-practice-id)))
    (map-set cultural-practices
      { practice-id: practice-id }
      {
        name: name,
        description: description,
        origin-site: origin-site,
        preservation-priority: preservation-priority,
        documented-by: tx-sender,
        documentation-date: block-height
      }
    )
    (var-set next-practice-id (+ practice-id u1))
    (ok practice-id)
  )
)

(define-public (contribute-to-preservation
  (site-id uint)
  (contribution-type (string-ascii 50))
  (amount uint)
  (description (string-ascii 200))
)
  (let ((contribution-id (var-get next-contribution-id)))
    (asserts! (is-some (map-get? cultural-sites { site-id: site-id })) ERR_NOT_FOUND)

    (map-set preservation-contributions
      { contribution-id: contribution-id }
      {
        contributor: tx-sender,
        site-id: site-id,
        contribution-type: contribution-type,
        amount: amount,
        description: description,
        contributed-at: block-height
      }
    )
    (var-set next-contribution-id (+ contribution-id u1))
    (ok contribution-id)
  )
)

(define-public (update-preservation-status
  (site-id uint)
  (new-status (string-ascii 50))
)
  (match (map-get? cultural-sites { site-id: site-id })
    site-data
    (begin
      (asserts! (is-eq tx-sender (get guardian site-data)) ERR_UNAUTHORIZED)
      (map-set cultural-sites
        { site-id: site-id }
        (merge site-data { preservation-status: new-status })
      )
      (ok true)
    )
    ERR_NOT_FOUND
  )
)

;; Read-only functions
(define-read-only (get-cultural-site (site-id uint))
  (map-get? cultural-sites { site-id: site-id })
)

(define-read-only (get-cultural-practice (practice-id uint))
  (map-get? cultural-practices { practice-id: practice-id })
)

(define-read-only (get-contribution-info (contribution-id uint))
  (map-get? preservation-contributions { contribution-id: contribution-id })
)

(define-read-only (get-site-guardian (site-id uint))
  (match (map-get? cultural-sites { site-id: site-id })
    site-data (some (get guardian site-data))
    none
  )
)
