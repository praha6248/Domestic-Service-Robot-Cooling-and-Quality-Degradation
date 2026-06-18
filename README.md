# Domestic-Service-Robot-Cooling-and-Quality-Degradation
# Project: Domestic Service Robot - Cooling and Quality Degradation

## Project Overview
The project models a domestic service robot operating as an autonomous barista in a coffee shop environment. The robot (CafeBot) is equipped with a single manipulator (one-hand configuration), which introduces a physical constraint: it can hold only one beverage at a time. The objective is to demonstrate how delays in service lead to quality degradation and, ultimately, failure to serve the product.

---

## Q1: Classical PDDL Model

### PDDL Model Explanation
The model uses discrete state modeling to represent quality levels.
* **Quality states**: `Hot-fresh`, `Warm-acceptable`, and `Cold-degraded` are modeled as predicates.
* **Logic**: A conditional effect (`when`) is used to simulate quality loss over time, where each movement step forces a transition to a lower quality state. The robot can serve the dish only if it is `hot-fresh` or `warm-acceptable`. When it is `cold-degraded`, it is not serviceable. Each move action triggers a conditional effect that transitions the coffee state from `hot-fresh` to `warm-acceptable`, and eventually to `cold-degraded`.

### Functions used in domain
The `total-cost` function acts as a heuristic metric to optimize service efficiency. By assigning specific weights to actions (move operations costing 5, quality-degradation transitions costing 10), we mathematically incentivize the robot to prioritize speed. This ensures the robot selects the most efficient route and task sequence, reinforcing the 'delay leads to failure' constraint.

### Plans and Problems

#### Problem when timing is irrelevant
The goal is to serve black-coffee and espresso. As the path is short, the beverage cannot get `cold-degraded` while the robot is serving coffee.

**Generated plan:**
0.0: (pick-coffee cafebot black_coffee coffee_machine)
1.0: (move cafebot coffee_machine serving_area)
2.0: (check-temperature cafebot black_coffee)
3.0: (serve-coffee-warm cafebot black_coffee serving_area)
4.0: (move cafebot serving_area coffee_machine)
5.0: (pick-coffee cafebot espresso coffee_machine)
6.0: (move cafebot coffee_machine serving_area)
7.0: (check-temperature cafebot espresso)
8.0: (serve-coffee-warm cafebot espresso serving_area)
#### Problem when delays lead to failure
The goal is to serve espresso. The route is elongated by multiple points, making it impossible for the robot to serve the coffee in an acceptable state.

**Generated plan:**
*Plan not found, as the delay in this problem leads to failure.*

### Discussion
This discussion highlights the importance of environmental topology in robotic planning. In real-world service robotics, task success is not only defined by reaching a destination but by maintaining product integrity under temporal constraints.

---

## Q2: PDDL+ Model

### PDDL+ Model Explanation
The model shifts from symbolic discrete transitions to hybrid dynamical modeling.
* **Continuous Dynamics**: We utilize `:process` to model the autonomous cooling of beverages (`cooling`) and the passage of time (`timer-process`), where `(decrease (temperature ?d) (* #t 2.0))` allows for continuous state evolution.
* **Events**: Threshold-based transitions are managed via `:event`. For example, `end-move` and `end-pick` trigger automatically once the action timer hits its threshold, representing physical reality more accurately than instantaneous discrete actions.
* **Autonomous Dynamics**: The barista does not "cause" the coffee to cool; the world evolves independently of the planner's actions. Planning involves reasoning over continuous trajectories, ensuring the `temperature` remains above the threshold (40) upon arrival at the serving zone.

### Functions used in domain
* `temperature ?d`: A continuous fluent tracking the beverage's heat.
* `action-timer ?r`: A fluent tracking the duration of ongoing robot actions.
* `total-cost`: A heuristic metric to penalize excessive service time.

### Plans and Problems

#### Problem when timing is irrelevant
The goal is to serve two beverages. The plan is feasible as the robot coordinates tasks within the temperature threshold.

**Generated plan:**
0: (pick-coffee cafebot black_coffee coffee_machine)
0: -----waiting---- [2.0]
2.0: (move cafebot coffee_machine serving_area)
2.0: -----waiting---- [11.0]
11.0: (serve-coffee cafebot black_coffee serving_area)
11.0: (move cafebot serving_area coffee_machine)
11.0: -----waiting---- [16.0]
16.0: (pick-coffee cafebot espresso coffee_machine)
16.0: -----waiting---- [18.0]
18.0: (move cafebot coffee_machine serving_area)
18.0: -----waiting---- [23.0]
23.0: (serve-coffee cafebot espresso serving_area)
#### Problem when delays lead to failure
Due to the number of beverages (three instead of two), the `timer-process` forces the robot to spend more cumulative time. The continuous cooling process causes the temperature of the third beverage to drop below 40 before arrival.

**Generated plan:**
*Plan not found due to threshold violation.*

### Discussion
* **Planning as Trajectory Reasoning**: Unlike the Q1 model, degradation here is autonomous and continuous. This is a faithful representation of physical reality, where inaction has a cost.
* **System Constraints**: The inability to serve the third coffee highlights that task scheduling is fundamentally limited by the underlying environmental dynamics. This model proves that identifying "failure by delay" is a matter of predicting threshold violations in continuous state variables.
