class @Vector
    @x = 0
    @y = 0

    constructor: (x, y) ->
        @x = x
        @y = y

    magnitude: ->
        return Math.sqrt(Math.pow(@x, 2) + Math.pow(@y, 2))

    normalize: ->
        return @divide_num @magnitude()

    subtract: (other) ->
        vec = new Vector(0, 0)
        vec.x = @x - other.x
        vec.y = @y - other.y
        return vec

    add: (other) ->
        vec = new Vector(0, 0)
        vec.x = @x - other.x
        vec.y = @y - other.y
        return vec

    divide_num: (other) ->
        vec = new Vector @x, @y
        vec.x /= other
        vec.y /= other
        return vec

    mult_num: (other) ->
        vec = new Vector @x, @y
        vec.x *= other
        vec.y *= other
        return vec


class @Box
    @name = ''
    @text = '42'
    @compText = ''
    @position = new Vector 0, 0
    @type = ''
    @boxID = 0
    @entryPoints = []
    @prevBox = null
    @yesBox = null
    @noBox = null

    constructor: (type) ->
        @type = type
        switch type
            when cmdName then @entryPoints = cmdEntries
            when evalName then @entryPoints = evalEntries
            when interName then @entryPoints = interEntries

    setText: (text) ->
        @text = text
        @compText = compile(text, @type)


@boxes = []

@GetBoxByCoords = (x, y) ->
    for box in @boxes
        if box.position.x == x and box.position.y == y
            return box

    return false

@DeleteBoxByID = (id) ->
    for i in [0...@boxes.length]
        if @boxes[i].boxID is id
            @boxes.splice i, 1
            return

@GetByID = (id) ->
    for i in [0...@boxes.length]
        if @boxes[i].boxID is id
            return @boxes[i]
