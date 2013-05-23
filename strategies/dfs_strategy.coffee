
_ = require 'underscore'

Strategy = require './strategy'
Matrix = require '../matrix'

class DfsSearch extends Strategy

    getName: -> "Depth First Search"

    _search: () ->
        @moves = @_unvisitedValidNeighbours @position, []

        while @moves.length
            ret = @_visit @moves.shift()
            return ret if ret?.length

        return false

    _visit: (move) ->
        @visitCount++
        return false if @_isPositionVisited move
        @_markPositionVisited move
        return move.getData() if @_isAtTarget move

        @moves = @_unvisitedValidNeighbours(move, move.getData()).concat @moves
        return false

module.exports = DfsSearch
