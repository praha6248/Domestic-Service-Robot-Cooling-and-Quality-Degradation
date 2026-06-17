(define (domain cafe-time-sensitive)
  (:requirements :typing :fluents :numeric-fluents :negative-preconditions :continuous-effects)

  (:types location robot dish - object)

  (:predicates
    (robot-at ?r - robot ?l - location)
    (dish-at ?d - dish ?l - location)
    (holding ?r - robot ?d - dish)
    (hand-empty ?r - robot)
    (coffee-machine-zone ?l - location)
    (serving-zone ?l - location)
    (inspected ?d - dish)
    (served ?d - dish)
    (busy ?r - robot)
    (moving-now ?r - robot ?to - location)
    (picking-now ?r - robot ?d - dish)
  )

  (:functions
    (temperature ?d - dish)
    (action-timer ?r - robot)
    (total-cost)
  )

  (:process cooling
    :parameters (?d - dish)
    :precondition (and (not (served ?d)) (> (temperature ?d) 0))
    :effect (decrease (temperature ?d) (* #t 2.0))
  )

  (:process timer-process
    :parameters (?r - robot)
    :precondition (busy ?r)
    :effect (increase (action-timer ?r) (* #t 1.0))
  )



  (:action move
    :parameters (?r - robot ?from ?to - location)
    :precondition (and (robot-at ?r ?from) (not (busy ?r)))
    :effect (and (busy ?r) (moving-now ?r ?to) (not (robot-at ?r ?from)) (assign (action-timer ?r) 0.0))
  )

  (:event end-move
    :parameters (?r - robot ?to - location)
    :precondition (and (moving-now ?r ?to) (>= (action-timer ?r) 5.0))
    :effect (and (not (busy ?r)) (not (moving-now ?r ?to)) (robot-at ?r ?to) (increase (total-cost) 5))
  )

  (:action pick-coffee
    :parameters (?r - robot ?d - dish ?l - location)
    :precondition (and (robot-at ?r ?l) (coffee-machine-zone ?l) (hand-empty ?r) (not (busy ?r)))
    :effect (and (busy ?r) (picking-now ?r ?d) (not (hand-empty ?r)) (assign (action-timer ?r) 0.0))
  )

  (:event end-pick
    :parameters (?r - robot ?d - dish)
    :precondition (and (picking-now ?r ?d) (>= (action-timer ?r) 2.0))
    :effect (and (not (busy ?r)) (not (picking-now ?r ?d)) (holding ?r ?d) (increase (total-cost) 2))
  )

  (:action serve-coffee
    :parameters (?r - robot ?d - dish ?l - location)
    :precondition (and (holding ?r ?d) (robot-at ?r ?l) (serving-zone ?l) (> (temperature ?d) 40))
    :effect (and (served ?d) (not (holding ?r ?d)) (hand-empty ?r) (increase (total-cost) 1))
  )
)