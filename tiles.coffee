
require 'colors'
_ = require 'underscore'

directions = (require './directions').directions

tiles =
    EMPTY:              '-'.grey
    SNAKE_HEAD_UP:      '^'.bold
    SNAKE_HEAD_DOWN:    'v'.bold
    SNAKE_HEAD_LEFT:    '<'.bold
    SNAKE_HEAD_RIGHT:   '>'.bold
    SNAKE_BODY:         'S'
    SNAKE_TAIL:         's'
    FOOD:               'F'.yellow.bold
    BARRIER:            '#'.red.bold

directionToTile = (direction) ->
    switch direction
        when directions.UP then tiles.SNAKE_HEAD_UP
        when directions.DOWN then tiles.SNAKE_HEAD_DOWN
        when directions.LEFT then tiles.SNAKE_HEAD_LEFT
        when directions.RIGHT then tiles.SNAKE_HEAD_RIGHT
        else tiles.EMPTY

class Tile
    content: tiles.EMPTY
    properties: {}

    constructor: ->
        _.bindAll(@)

    getContent: -> @content

    getProperty: (prop) -> @properties[prop]

    setContent: (content) -> @content = content

    setProperty: (prop, val) -> @properties[prop] = val

module.exports = {
    directionToTile
    tiles
    Tile
}
