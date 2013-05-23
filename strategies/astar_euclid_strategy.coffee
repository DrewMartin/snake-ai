
AStar = require './astar'

class AStarEuclid extends AStar

    getName: -> "A* Euclid"

    heuristic: (move) ->
        x = move.getX() - @targetPos.getX()
        y = move.getY() - @targetPos.getY()
        Math.sqrt x * x + y * y

module.exports = AStarEuclid
