_ = require 'underscore'
colors = require 'colors'

strategies = require('./strategies').strategies

optimist = require('optimist')
    .boolean(['i', 'd', 'v', 'g'])
    .default(
        f: 1
        h: 20
        w: 20
        i: false
        l: 5
        c: 1
        b: 10
        s: 'astar_average'
        d: false
        v: false
        g: false
    )
    .alias(
        f: 'fps'
        h: 'height'
        w: 'width'
        i: 'interactive'
        l: 'length'
        c: 'snakes'
        b: 'barriers'
        s: 'search'
        g: 'grow'
        d: 'debug'
        v: 'verbose'
    )
    .describe('f', 'FPS of the game')
    .describe('h', 'Height of the game board')
    .describe('w', 'Width of the game board')
    .describe('i', 'Interactive mode')
    .describe('l', 'Length of the snake')
    .describe('c', 'Number of snakes')
    .describe('b', 'Number of barriers')
    .describe('s', 'Strategy')
    .describe('g', 'The snake grows as it eats food')
    .describe('v', 'Verbose')
    .describe('d', 'Debug mode')
    .describe('help', 'Show this message')

acceptedStrategies = _.keys(strategies).concat ['all']
options = {}

showHelp = ->
    optimist.showHelp()
    console.error "Valid search strategies are:", acceptedStrategies.join(', ')
    console.error "All is a special strategy where all the the snakes will each be"
    console.error "assigned one of the possible strategies in a round-robin manner\n"

parseAndCheckArguments = ->
    argv = optimist.argv
    if argv.help
        showHelp()
        return process.exit 0

    options =
        fps:            argv.fps
        height:         argv.height
        width:          argv.width
        interactive:    argv.interactive
        length:         argv.length
        snakes:         argv.snakes
        barriers:       argv.barriers
        search:         argv.search
        debug:          argv.debug
        verbose:        argv.verbose
        grow:           argv.grow

    if options.debug
        options.interactive = true
        options.snakes = 1
        options.search = 'all'
        options.verbose = true

    errors = []
    errors.push "Minimum board height is 10" if options.height < 10
    errors.push "Minimum board width is 10" if options.width < 10
    errors.push "Minimum snake length is 2" if options.length < 2
    if (options.length > options.height / 2) or (options.length > options.width / 2)
        errors.push "The snake length cannot be longer than half the board width or height"
    if (options.snakes > options.height / 2) or (options.snakes > options.width / 2)
        errors.push "The number of snakes cannot be more than half the board width or height"
    maxBarriers = Math.floor options.width*options.width/9
    if options.barriers > maxBarriers
        errors.push "The number of barriers cannot be more than the #{maxBarriers}"

    options.search = [options.search] unless _.isArray options.search
    for search in options.search
        errors.push "Unknown search strategy: #{search}" unless search in acceptedStrategies

    if 'all' in options.search
        options.search = _.values strategies
    else
        strats = []
        for search in options.search
            strats.push strategies[search]
        options.search = strats


    if errors.length
        console.error "Bad arguments given:".red.bold
        console.error msg.red.bold for msg in errors
        console.error()
        showHelp()
        process.exit 0

parseAndCheckArguments()


exports.getOption = (opt) ->
    options[opt]

