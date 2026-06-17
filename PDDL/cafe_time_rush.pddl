(define (problem cafe_too_late)
  (:domain cafe)
  (:objects
    CafeBot - robot
    coffee_machine p1 p2 p3 p4 serving_area trash_bin - location 
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
    (hot-fresh espresso)
    
    (connected coffee_machine p1)
    (connected p1 coffee_machine)
    (connected p1 p2)
    (connected p2 p1)
    (connected p2 serving_area)
    (connected serving_area p2)
  )
  (:goal
    (served espresso)
  )
  (:metric minimize (total-cost))
)