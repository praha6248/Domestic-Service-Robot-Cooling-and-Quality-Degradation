(define (problem cafe_race_unsolvable)
  (:domain cafe-pddlplus)
  (:objects
    CafeBot - robot
    coffee_machine serving_area - location
    black_coffee espresso latte - dish
  )
  (:init
    (coffee-machine-zone coffee_machine)
    (serving-zone serving_area)
    (robot-at CafeBot coffee_machine)
    (hand-empty CafeBot)
    (dish-at black_coffee coffee_machine)
    (dish-at espresso coffee_machine)
    (dish-at latte coffee_machine)
    (= (temperature espresso) 95)
    (hot-fresh espresso)
    (= (temperature black_coffee) 47)
    (warm-acceptable black_coffee)
    (= (temperature latte) 48)
    (warm-acceptable latte)
  )
  (:goal
    (and
      (served black_coffee)
      (served espresso)
      (served latte)
    )
  )
  (:metric minimize (total-time))
)