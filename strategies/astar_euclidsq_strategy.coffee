
AStar = require './astar'

class AStarEuclidSq extends AStar

    getName: -> "A* Euclid Squared"

    heuristic: (move) ->
        x = move.getX() - @targetPos.getX()
        y = move.getY() - @targetPos.getY()
        x * x + y * y

module.exports = AStarEuclidSq
