
_ = require 'underscore'

Strategy = require './strategy'
Matrix = require '../matrix'

class BfsSearch extends Strategy

    getName: -> "Breadth First Search"

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
        @moves = @moves.concat @_unvisitedValidNeighbours(move, move.getData())
        return false

module.exports = BfsSearch
