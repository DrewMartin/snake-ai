
options = require './options'

read = require 'read'

Board = require './board'

frameRate = Math.floor 1000/options.getOption 'fps'


showPrompt = (prompt, done) ->
    read {prompt}, (err, input) ->
        if err or /^q/.test input
            console.log "Goodbye!"
            return process.exit 0
        done()


gameLoop = (board) ->
    start = new Date()
    board.update()
    if options.getOption 'verbose'
        finish = new Date()
        console.log "Took", (finish-start), "ms to update"
    console.log board.toString()
    finish = new Date()


    onFinish = ->
        gameLoop board

    if options.getOption 'interactive'
        showPrompt "Enter q to quit, anything else to update: ", onFinish
    else
        setTimeout onFinish, Math.max(frameRate - finish.getTime() + start.getTime(), 0)

board = new Board()

console.log board.toString()

showPrompt "Press enter to start or q to quit: ", ->
    gameLoop board
