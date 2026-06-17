(define (problem cafe_race_solvable)
  (:domain cafe-pddlplus)
  (:objects
    CafeBot - robot
    coffee_machine serving_area - location
    black_coffee espresso - dish
  )
  (:init
    (coffee-machine-zone coffee_machine)
    (serving-zone serving_area)
    (robot-at CafeBot coffee_machine)
    (hand-empty CafeBot)
    (dish-at black_coffee coffee_machine)
    (dish-at espresso coffee_machine)
    (= (temperature espresso) 95)
    (hot-fresh espresso)
    (= (temperature black_coffee) 75)
    (hot-fresh black_coffee)
  )
  (:goal
    (and
      (served black_coffee)
      (served espresso)
    )
  )
  (:metric minimize (total-time))
)