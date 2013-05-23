
_ = require 'underscore'

directions = require '../directions'
tiles = require '../tiles'
Matrix = require '../matrix'
Pos = require '../pos'
options = require '../options'

class Strategy
    visitCount: 0

    constructor: (@positions, @targetPos, @matrix) ->
        _.bindAll(@)
        @position = @positions[0]
        @tailPos = _.last @positions
        @history = new Matrix @matrix.width, @matrix.height

    search: ->
        path = @_search()
        if path?.length
            if options.getOption 'verbose'
                console.log "Path length found using #{@getName()}:", path.length, "after visiting", @visitCount, "nodes"
            return [path[0]] if options.getOption('snakes') > 1
            return path

        backup = @_tryBackup()
        if backup
            console.log "No valid path found. Backing the snake up" if options.getOption 'verbose'
            return backup if backup

        neighbours = _.filter @_createNeighbourMoves(@position, []), (neighbour) =>
            @_isPositionOnBoard(neighbour) and @_isEmptyOrFoodTile(neighbour)

        if neighbours.length
            console.log "No valid path found and could not back up. Moving in a random direction" if options.getOption 'verbose'
            return neighbours[_.random(neighbours.length-1)].getData()

        console.log "No moves found. Snake will idle." if options.getOption 'verbose'
        return false

    getName: ->
        throw "Strategy.getName must be implemented for all subclasses"

    _search: ->
        throw "Strategy._search should be implemented for all subclasses"

    _canMoveTo: (pos) ->
        @_isPositionOnBoard(pos) and !@_isPositionVisited(pos) and @_isEmptyOrFoodTile(pos)

    _createNeighbourMoves: (pos, dirList=[]) ->
        [
            new Pos(pos.getX(), pos.getY()-1, dirList.concat [directions.directions.UP]),
            new Pos(pos.getX()+1, pos.getY(), dirList.concat [directions.directions.RIGHT]),
            new Pos(pos.getX(), pos.getY()+1, dirList.concat [directions.directions.DOWN]),
            new Pos(pos.getX()-1, pos.getY(), dirList.concat [directions.directions.LEFT])
        ]

    _isAtTarget: (pos) ->
        pos.getX() == @targetPos.getX() and pos.getY() == @targetPos.getY()

    _isPositionOnBoard: (pos) ->
        x = pos.getX()
        y = pos.getY()

        x >= 0 and x < @matrix.getWidth() and y >= 0 and y < @matrix.getHeight()

    _isEmptyTile: (pos) ->
        item = @matrix.getContentAt pos
        item.getContent() == tiles.tiles.EMPTY

    _isEmptyOrFoodTile: (pos) ->
        item = @matrix.getContentAt pos
        (item.getContent() == tiles.tiles.FOOD or item.getContent() == tiles.tiles.EMPTY)

    _isPositionVisited: (pos) ->
        !!@history.getContentAt(pos).visited

    _markPositionVisited: (pos) ->
        @history.callOnItemAt pos, (item) ->
            item.visited = true

    _tryBackup: ->
        tailNeighbours = _.filter @_createNeighbourMoves(@tailPos), (neighbour) =>
            @_isPositionOnBoard(neighbour) and @_isEmptyTile(neighbour)
        return false if !tailNeighbours.length
        tailX = @tailPos.getX()
        tailY = @tailPos.getY()
        prevX = @positions[@positions.length - 2].getX()
        prevY = @positions[@positions.length - 2].getY()
        rightBehind = new Pos(2*tailX - prevX, 2*tailY - prevY)
        tailNeighbours.sort (p1, p2) ->
            return -1 if p1.equals rightBehind
            return 1 if p2.equals rightBehind
            return _.random(2) - 1
        behind = tailNeighbours[0]
        return [directions.backDir behind.getData()[0]]

    _unvisitedValidNeighbours: (pos, dirList) ->
        moves = @_createNeighbourMoves pos, dirList

        moves = _.filter moves, (move) =>
            @_canMoveTo move

        return moves

module.exports = Strategy
