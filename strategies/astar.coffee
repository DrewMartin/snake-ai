
_ = require 'underscore'

Strategy = require './strategy'
Matrix = require '../matrix'
Heap = require 'heap'

class AStar extends Strategy

    heuristic: ->
        throw "AStar.heuristic should be implemented for all subclasses"

    _search: ->
        @moves = new Heap (m1, m2) =>
            (m1.cost + @heuristic(m1)) - (m2.cost + @heuristic(m2))

        @position.setData []
        @position.cost = 0

        @_visit @position

        while !@moves.empty()
            ret = @_visit @moves.pop()
            return ret if ret?.length

        return false

    _visit: (move) ->
        @visitCount++
        return false if @_isPositionVisited move
        @_markPositionVisited move
        return move.getData() if @_isAtTarget move

        moves = @_unvisitedValidNeighbours(move, move.getData())

        _.each moves, (newMove) =>
            newMove.cost = move.cost + 1
            @moves.push newMove

        return false

module.exports = AStar