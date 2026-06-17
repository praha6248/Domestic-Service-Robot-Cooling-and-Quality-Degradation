(define (problem cafe_easy_no_time_pressure)
  (:domain cafe)
  (:objects
    CafeBot - robot
    coffee_machine serving_area - location
    black_coffee espresso - dish
  )
  (:init
    (= (total-cost) 0)
    (coffee-machine-zone coffee_machine)
    (serving-zone serving_area)
    (robot-at CafeBot coffee_machine)
    (hand-empty CafeBot)
    (dish-at black_coffee coffee_machine)
    (dish-at espresso coffee_machine)
    (hot-fresh black_coffee)
    (hot-fresh espresso)
  )
  (:goal
    (and
      (served black_coffee)
      (served espresso)
    )
  )
  (:metric minimize (total-cost))
)