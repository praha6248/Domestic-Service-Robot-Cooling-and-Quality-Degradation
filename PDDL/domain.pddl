(define (domain cafe)
  (:requirements :strips :typing :negative-preconditions :action-costs)

  (:types
    location robot dish - object
  )

  (:predicates
    (robot-at ?r - robot ?l - location)
    (dish-at ?d - dish ?l - location)
    (holding ?r - robot ?d - dish)
    (hand-empty ?r - robot)
    (coffee-machine-zone ?l - location)
    (serving-zone ?l - location)
    (trash-zone ?l - location)
    (hot-fresh ?d - dish)
    (warm-acceptable ?d - dish)
    (cold-degraded ?d - dish)
    (inspected ?d - dish)
    (served ?d - dish)
  )

  (:functions
    (total-cost)
  )

  (:action move
    :parameters (?r - robot ?from ?to - location)
    :precondition (robot-at ?r ?from)
    :effect (and
      (not (robot-at ?r ?from))
      (robot-at ?r ?to)
      (increase (total-cost) 5)
    )
  )

  (:action pick-coffee
    :parameters (?r - robot ?d - dish ?l - location)
    :precondition (and
      (robot-at ?r ?l)
      (coffee-machine-zone ?l)
      (dish-at ?d ?l)
      (hand-empty ?r)
    )
    :effect (and
      (not (hand-empty ?r))
      (holding ?r ?d)
      (not (dish-at ?d ?l))
      (increase (total-cost) 1)
    )
  )

  (:action check-temperature
    :parameters (?r - robot ?d - dish)
    :precondition (and
      (holding ?r ?d)
      (not (inspected ?d))
    )
    :effect (and
      (inspected ?d)
      (increase (total-cost) 3)
    )
  )
  
  (:action age-hot-to-warm
    :parameters (?d - dish)
    :precondition (hot-fresh ?d)
    :effect (and
      (not (hot-fresh ?d))
      (warm-acceptable ?d)
      (increase (total-cost) 10)
    )
  )

  (:action age-warm-to-cold
    :parameters (?d - dish)
    :precondition (warm-acceptable ?d)
    :effect (and
      (not (warm-acceptable ?d))
      (cold-degraded ?d)
      (increase (total-cost) 10)
    )
  )

  ; -----------------------------------------------------------
  ; SERVE - one action per acceptable quality level
  ; -----------------------------------------------------------
  (:action serve-coffee-hot
    :parameters (?r - robot ?d - dish ?l - location)
    :precondition (and
      (inspected ?d)
      (hot-fresh ?d)
      (serving-zone ?l)
      (robot-at ?r ?l)
      (holding ?r ?d)
    )
    :effect (and
      (served ?d)
      (not (holding ?r ?d))
      (hand-empty ?r)
      (increase (total-cost) 1)
    )
  )

  (:action serve-coffee-warm
    :parameters (?r - robot ?d - dish ?l - location)
    :precondition (and
      (inspected ?d)
      (warm-acceptable ?d)
      (serving-zone ?l)
      (robot-at ?r ?l)
      (holding ?r ?d)
    )
    :effect (and
      (served ?d)
      (not (holding ?r ?d))
      (hand-empty ?r)
      (increase (total-cost) 1)
    )
  )

  ; -----------------------------------------------------------
  ; cold-degraded coffee can only be discarded, never served
  ; -----------------------------------------------------------
  (:action discard-cold-coffee
    :parameters (?r - robot ?d - dish ?l - location)
    :precondition (and
      (robot-at ?r ?l)
      (trash-zone ?l)
      (inspected ?d)
      (cold-degraded ?d)
      (holding ?r ?d)
    )
    :effect (and
      (not (holding ?r ?d))
      (hand-empty ?r)
      (dish-at ?d ?l)
      (increase (total-cost) 1)
    )
  )
)