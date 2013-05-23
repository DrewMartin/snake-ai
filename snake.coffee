
_ = require 'underscore'

Pos = require './pos'
directions = require './directions'
tiles = require './tiles'
options = require './options'


class Snake
    moves: []

    constructor: (head, @length, @strategy) ->
        _.bindAll(@)
        @positions = @_createSnakePositions(@length, head)
        @direction = directions.directions.LEFT

    getDirection: -> @direction

    getPositionList: -> @positions

    setFoodPos: (pos) ->
        @foodPos = pos
        #invalidates move list
        @moves = []

    update: (matrix) ->
        if !@_isNextMoveValid matrix
            @_findNextMoves matrix

        if @moves and @moves.length
            @_moveSnake()

    _createSnakePositions: (length, head) ->
        x = head.getX()
        y = head.getY()
        _.map [0...length], (i) ->
            new Pos(x+i, y)

    _findFood: (matrix) ->
        matrix.findFirst (tile) ->
            tile.getContent == tiles.tiles.FOOD

    _findNextMoves: (matrix) ->
        if options.getOption 'debug'
            return @_findNextMovesDebug(matrix)
        moves = new @strategy(@positions, @foodPos, matrix).search()

        @moves = moves

    _findNextMovesDebug: (matrix) ->
        searches = {}
        best = undefined
        _.each options.getOption('search'), (strategy) =>
            strat = new strategy(@positions, @foodPos, matrix)
            search = strat.search()
            searches[strat.getName()] = search
            if search.length > 0 and (!best or search.length < searches[best].length)
                best = strat.getName()

        @moves = [searches[best][0]]

    _isNextMoveValid: (matrix) ->
        return false if !@moves.length
        nextPos = @_nextPosBasedOnMove @positions[0], @moves[0]
        content = matrix.getContentAt(nextPos).getContent()
        content == tiles.tiles.FOOD or content == tiles.tiles.EMPTY

    _moveSnake: ->
        nextMove = @moves.shift()
        if !directions.isBehind(nextMove)
            nextPos = @_nextPosBasedOnMove @positions[0], nextMove
            @positions.unshift nextPos
            unless nextPos && nextPos.equals(@foodPos) and options.getOption 'grow'
                @positions.pop()
            @direction = nextMove
        else
            tailNextPos = @_nextPosBasedOnMove _.last(@positions), nextMove
            unless nextPos && nextPos.equals(@foodPos) and options.getOption 'grow'
                @positions.shift()
            @positions.push tailNextPos
            @direction = directions.frontDir nextMove

    _nextPosBasedOnMove: (pos, move) ->
        new Pos(pos.getX() + directions.xDelta(move), pos.getY() + directions.yDelta(move))

module.exports = Snake
