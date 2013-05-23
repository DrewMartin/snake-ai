Comp 4106 Assignment 1
Drew Martin
100784541

The state of the game is represented as a matrix of objects, each object
containing information about its contents. For example, it could be empty,
food, a barrier, the head of the snake facing left, the body of the snake, etc.
The snake is given knowledge of the whole state of the game, and it knows where
the food is that it's looking for, as well as any barriers on the board, and the
current positions of any other snakes, if any.

I named the two heuristics for A* 'linear' and 'euclid'.

The euclidean heuristic calculates the euclidean distance between the head of
the snake and the food: sqrt((head.x - food.x)^2 + (head.y - food.y)^2). Since
this gives the shortest possible distance between the snake and the food, it
seems like a decent heuristic. However, there is one failing: it will always
underestimate the distance unless the snake is on one of the same axes as the
food, since it cannot move diagonally.

The linear heuristic calculates the distance along the grid between the snake's
head and the food, ignoring any other objects which might be in the way.
Essentially, it's abs(head.x - food.x) + abs(head.y - food.y). This heuristic
dominates the euclidean heuristic because it only accounts for moves along the
x and y axes. Since the snake cannot move diagonally, this should give a move
count that is closer the the actual value.

They are both good heuristics because they will underestimate the cost to get
to the food. If the food is on one of the same axes as the snake's head and
there are are no obstacles in the way, then the values the heuristic gives are
the smallest possible moves. However, if there is somehing in the way, then they
will underestimate the distance. Furthermore, if the snake is not on the same
x and y axes as the food, the euclidean heuristic must underestimate the
distance because it uses diagonal distance. For example, if the snake is 1 unit
along the x and one unit along the y axes away from the food, the euclidean
heuristic will give a value of ~1.4 but the actual distance the snake must move
is at least two.

The linear heuristic will give a tighter bound because, if there are no barriers
between the snake and the food, its estimate will be the correct distance.

