
_ = require 'underscore'
require 'colors'

Pos = require './pos'
Matrix = require './matrix'
tiles = require './tiles'
Snake = require './snake'
options = require './options'

snakeColors = [
    'green'
    'magenta'
    'cyan'
    'blue'
    'yellow'
    'white'
    'red'
]

class Board
    snakes: []
    snakeEatCount: []

    constructor: () ->
        _.bindAll(@)
        @matrix = new Matrix(options.getOption('width'), options.getOption('height'), tiles.Tile)
        @_createSnakes options.getOption('snakes')
        @_createBarriers options.getOption('barriers')
        @_createFood()

    getHeight: -> @matrix.getHeight()

    getWidth: -> @matrix.getWidth()

    toString: ->
        end = @_makeEnd().white.bold
        rowStrs = @matrix.map (tile) -> tile.getContent()
        rowStrs = _.map rowStrs, (row) ->
            row.join ' '
        end + "\n| ".white.bold + rowStrs.join(" |\n| ".white.bold) + " |\n".white.bold + end

    update: ->
        @_updateSnakes()

    _clearPos: (pos) ->
        @matrix.clearPos pos

    _createBarrier: ->
        pos = @_getRandomEmptySpace()
        if !@_doSurroundingSpacesContainBarrier pos
            @_populateTile pos, tiles.tiles.BARRIER
        else
            @_createBarrier()

    _createBarriers: (count) ->
        _.each [0...count], =>
            @_createBarrier()

    _createFood: ->
        pos = @_getRandomEmptySpace()
        @foodPos = pos
        @_populateTile pos, tiles.tiles.FOOD
        _.each @snakes, (snake) ->
            snake.setFoodPos pos

    _createSnake: (num) ->
        pos = new Pos(@_makeFuzzy(@getWidth() - options.getOption('length') - 1, 1),
            Math.floor (@getHeight()*num)/(options.getOption('snakes') + 1))
        searches = options.getOption('search')
        new Snake(pos, options.getOption('length'), searches[(num-1) % searches.length])

    _createSnakes: (count) ->
        @snakes = _.map [1..count], (i) =>
            @snakeEatCount.push 0
            @_createSnake(i)
        @_populateMatrixWithSnakes()

    _doesSpaceContainBarrier: (pos) ->
        x = pos.getX()
        y = pos.getY()
        return false if x < 0 or x >= @getWidth() or y < 0 or y >= @getHeight()
        return @_getMatrixContentAt(pos) == tiles.tiles.BARRIER

    _doSurroundingSpacesContainBarrier: (pos) ->
        x = pos.getX()
        y = pos.getY()
        f = @_doesSpaceContainBarrier
        return f(new Pos(x-1, y-1)) or f(new Pos(x, y-1)) or f(new Pos(x+1, y-1)) or
               f(new Pos(x-1, y))   or                       f(new Pos(x+1, y))   or
               f(new Pos(x-1, y+1)) or f(new Pos(x, y+1)) or f(new Pos(x+1, y+1))

    _getMatrixContentAt: (pos) ->
        @matrix.getContentAt(pos).getContent()

    _getRandomEmptySpace: ->
        pos = new Pos(_.random(@getWidth()-1), _.random(@getHeight()-1))
        if @_isMatrixEmptyAt pos
            return pos
        return @_getRandomEmptySpace()

    _isMatrixEmptyAt: (pos) ->
        @_getMatrixContentAt(pos) == tiles.tiles.EMPTY

    _makeEnd: ->
        result = ''
        pattern = '-'
        width = @getWidth() * 2 + 3

        while width > 0
            result += pattern if width & 1
            width >>= 1
            pattern += pattern

        return result

    _makeFuzzy: (num, range) ->
        _.random(num - range, num + range)

    _populateMatrixWithSnake: (snake, i) ->
        positions = snake.getPositionList()
        color = snakeColors[i % snakeColors.length]
        @_populateTile positions[0], tiles.directionToTile(snake.getDirection())[color]
        _.each positions[1...-1], (pos) =>
            @_populateTile pos, tiles.tiles.SNAKE_BODY[color]
        @_populateTile _.last(positions), tiles.tiles.SNAKE_TAIL[color]

    _populateMatrixWithSnakes: ->
        _.each @snakes, (snake, i) =>
            @_populateMatrixWithSnake snake, i

    _populateTile: (pos, content) ->
        @matrix.callOnItemAt pos, (tile) ->
            tile.setContent content

    _removeSnakeFromMatrix: (snakePos) ->
        _.each snakePos, (pos) =>
            @_clearPos pos

    _updateSnakes: ->
        _.each @snakes, (snake, i) =>
            oldPos = _.clone snake.getPositionList()
            snake.update @matrix
            if snake.getPositionList()[0].equals @foodPos
                @snakeEatCount[i]++
                if options.getOption 'verbose'
                    _.each @snakeEatCount, (count, i) ->
                        console.log "Snake", "#{i}"[snakeColors[i % snakeColors.length]].bold, "has eaten #{count} food"
                @_createFood()
            @_removeSnakeFromMatrix oldPos
            @_populateMatrixWithSnake snake, i

module.exports = Board
