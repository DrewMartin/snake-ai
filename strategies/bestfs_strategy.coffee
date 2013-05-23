
_ = require 'underscore'

Strategy = require './strategy'
Matrix = require '../matrix'

class BestFirstSearch extends Strategy

    getName: -> "Best First Search"

    _search: () ->
        @moves = @_unvisitedValidNeighbours @position, []
        @moves = @_sortMovesByDistance @moves

        while @moves.length
            ret = @_visit @moves.shift()
            return ret if ret?.length

        return false

    _visit: (move) ->
        @visitCount++
        return false if @_isPositionVisited move
        @_markPositionVisited move
        return move.getData() if @_isAtTarget move
        moves = @_unvisitedValidNeighbours(move, move.getData())
        moves = @_sortMovesByDistance moves
        @moves = moves.concat @moves
        return false

    _sortMovesByDistance: (moves) ->
        _.sortBy (moves), (move) =>
            @_calculateDistanceToTarget move

    _calculateDistanceToTarget: (move) ->
        Math.abs(move.getX() - @targetPos.getX()) + Math.abs(move.getY() - @targetPos.getY())

module.exports = BestFirstSearch
