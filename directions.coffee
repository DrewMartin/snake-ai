
directions =
    UP: 0
    RIGHT: 1
    DOWN: 2
    LEFT: 3
    BACK_UP: 4
    BACK_RIGHT: 5
    BACK_DOWN: 6
    BACK_LEFT: 7

xDelta = (dir) ->
    dir = frontDir dir
    switch(dir)
        when directions.RIGHT then 1
        when directions.LEFT then -1
        else 0

yDelta = (dir) ->
    dir = frontDir dir
    switch(dir)
        when directions.UP then -1
        when directions.DOWN then 1
        else 0

isBehind = (dir) ->
    dir >= directions.BACK_UP

flipFrontBehind = (dir) ->
    return dir + 4 if dir < directions.BACK_UP
    return dir - 4

backDir = (dir) ->
    4 + frontDir dir

frontDir = (dir) ->
    dir % 4

module.exports = {
    backDir
    directions
    flipFrontBehind
    frontDir
    isBehind
    xDelta
    yDelta
}
