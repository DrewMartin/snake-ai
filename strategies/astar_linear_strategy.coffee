
AStar = require './astar'

class AStarLinear extends AStar

    getName: -> "A* Linear"

    heuristic: (move) ->
        Math.abs(move.getX() - @targetPos.getX()) + Math.abs(move.getY() - @targetPos.getY())

module.exports = AStarLinear
