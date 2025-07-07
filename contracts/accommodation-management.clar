;; Accommodation Management Contract
;; Manages pilgrimage accommodations

(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_NOT_FOUND (err u301))
(define-constant ERR_UNAVAILABLE (err u302))
(define-constant ERR_ALREADY_BOOKED (err u303))

;; Data structures
(define-map accommodations
  { accommodation-id: uint }
  {
    provider: principal,
    name: (string-ascii 100),
    location: (string-ascii 100),
    capacity: uint,
    available-rooms: uint,
    price-per-night: uint,
    amenities: (string-ascii 200),
    verified: bool
  }
)

(define-map bookings
  { booking-id: uint }
  {
    accommodation-id: uint,
    guest: principal,
    check-in-date: uint,
    check-out-date: uint,
    rooms-booked: uint,
    total-cost: uint,
    status: (string-ascii 20)
  }
)

(define-data-var next-accommodation-id uint u1)
(define-data-var next-booking-id uint u1)

;; Public functions
(define-public (register-accommodation
  (name (string-ascii 100))
  (location (string-ascii 100))
  (capacity uint)
  (price-per-night uint)
  (amenities (string-ascii 200))
)
  (let ((accommodation-id (var-get next-accommodation-id)))
    (map-set accommodations
      { accommodation-id: accommodation-id }
      {
        provider: tx-sender,
        name: name,
        location: location,
        capacity: capacity,
        available-rooms: capacity,
        price-per-night: price-per-night,
        amenities: amenities,
        verified: false
      }
    )
    (var-set next-accommodation-id (+ accommodation-id u1))
    (ok accommodation-id)
  )
)

(define-public (book-accommodation
  (accommodation-id uint)
  (check-in-date uint)
  (check-out-date uint)
  (rooms-needed uint)
)
  (match (map-get? accommodations { accommodation-id: accommodation-id })
    accommodation-data
    (let (
      (booking-id (var-get next-booking-id))
      (nights (- check-out-date check-in-date))
      (total-cost (* (* rooms-needed (get price-per-night accommodation-data)) nights))
    )
      (asserts! (>= (get available-rooms accommodation-data) rooms-needed) ERR_UNAVAILABLE)

      (map-set bookings
        { booking-id: booking-id }
        {
          accommodation-id: accommodation-id,
          guest: tx-sender,
          check-in-date: check-in-date,
          check-out-date: check-out-date,
          rooms-booked: rooms-needed,
          total-cost: total-cost,
          status: "confirmed"
        }
      )

      (map-set accommodations
        { accommodation-id: accommodation-id }
        (merge accommodation-data { available-rooms: (- (get available-rooms accommodation-data) rooms-needed) })
      )

      (var-set next-booking-id (+ booking-id u1))
      (ok booking-id)
    )
    ERR_NOT_FOUND
  )
)

(define-public (verify-accommodation (accommodation-id uint))
  (match (map-get? accommodations { accommodation-id: accommodation-id })
    accommodation-data
    (begin
      (map-set accommodations
        { accommodation-id: accommodation-id }
        (merge accommodation-data { verified: true })
      )
      (ok true)
    )
    ERR_NOT_FOUND
  )
)

;; Read-only functions
(define-read-only (get-accommodation-info (accommodation-id uint))
  (map-get? accommodations { accommodation-id: accommodation-id })
)

(define-read-only (get-booking-info (booking-id uint))
  (map-get? bookings { booking-id: booking-id })
)

(define-read-only (check-availability (accommodation-id uint) (rooms-needed uint))
  (match (map-get? accommodations { accommodation-id: accommodation-id })
    accommodation-data (>= (get available-rooms accommodation-data) rooms-needed)
    false
  )
)
