
class Position
    constructor: (@x, @y, @data) ->

    equals: (otherPos) ->
        @x == otherPos.x and @y == otherPos.y

    getData: -> @data

    getX: -> @x
    getY: -> @y

    setData: (@data) ->

    setX: (@x) ->
    setY: (@y) ->

module.exports = Position
