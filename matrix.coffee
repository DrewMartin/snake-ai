
_   = require 'underscore'

Pos = require './pos'

class Matrix
    constructor: (@width, @height, def) ->
        _.bindAll(@)
        @defaultItem = def or -> {}
        @grid = _.map [0...height], =>
            _.map [0...width], =>
                new @defaultItem()

    callOnItemAt: (pos, fun) ->
        fun @getContentAt pos

    clearPos: (pos) ->
        @setItemAt pos, new @defaultItem()

    findFirst: (fun) ->
        _.find @grid, (row) ->
            _.find row, fun

    getContentAt: (pos) ->
        @grid[pos.getY()][pos.getX()]

    getHeight: -> @height

    getWidth: -> @width

    map: (fun) ->
        _.map @grid, (row) ->
            _.map row, fun

    setItemAt: (pos, obj) ->
        @grid[pos.getY()][pos.getX()] = obj


module.exports = Matrix
