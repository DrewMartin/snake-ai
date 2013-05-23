
AStar = require './astar'
AStarEuclid = require './astar_euclid_strategy'
AStarLinear = require './astar_linear_strategy'

class AStarAverage extends AStar

    constructor: (args...) ->
        super args...
        @linear = new AStarLinear args...
        @euclid = new AStarEuclid args...

    getName: -> "A* Average"

    heuristic: (move) ->
        (@linear.heuristic(move) + @euclid.heuristic(move))/2

module.exports = AStarAverage