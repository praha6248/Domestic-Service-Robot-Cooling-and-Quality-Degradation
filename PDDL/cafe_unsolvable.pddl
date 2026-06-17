(define (problem cafe_too_late)
  (:domain cafe)
  (:objects
    CafeBot - robot
    coffee_machine serving_area trash_bin - location
    espresso - dish
  )
  (:init
    (= (total-cost) 0)
    (coffee-machine-zone coffee_machine)
    (serving-zone serving_area)
    (trash-zone trash_bin)
    (robot-at CafeBot coffee_machine)
    (hand-empty CafeBot)
    (dish-at espresso coffee_machine)
    (cold-degraded espresso)
  )
  (:goal
    (served espresso)
  )
  (:metric minimize (total-cost))
)