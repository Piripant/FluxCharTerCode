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
    @boxID = 0

    constructor: (type) ->
        @type = type
        switch type
            when cmdName then @entryPoints = cmdEntries
            when evalName then @entryPoints = evalEntries
            when interName then @entryPoints = interEntries
            when 'start' then @entryPoints = cmdEntries
            when 'end' then @entryPoints = cmdEntries

        @prevBoxes = []
        @yesBox = null
        @noBox = null
        @position = new Vector 0, 0

    setText: (text) ->
        @text = text
        @compText = compile(text, @type)

    copy: ->
        copied = new Box(@type)
        copied.name = @name
        copied.text = @text
        copied.compText = @compText
        copied.boxID = @boxID
        copied.prevBoxes = @prevBoxes
        copied.yesBox = @yesBox
        copied.noBox = @noBox
        copied.position = new Vector 0, 0
        copied.position.x = @position.x
        copied.position.y = @position.y
        return copied


@boxes = []

@InitForms = ->
    startingBox = new Box('start')
    endingBox = new Box('end')

    startingBox.boxID = 0
    startingBox.position.x = 520
    startingBox.position.y = 208
    startingBox.name = 'Start'
    startingBox.text = 'Start'

    endingBox.boxID = 1
    endingBox.position.x = 520
    endingBox.position.y = 416
    endingBox.name = 'End'
    endingBox.text = 'End'

    @init_boxes = [startingBox, endingBox]
    @boxes = init_boxes

@CopyBoxes = (boxes=@boxes) ->
    cboxes = []
    for box in boxes
        cboxes.push box.copy()
    return cboxes

@GetBoxByCoords = (x, y, boxes=@boxes) ->
    for box in boxes
        if box.position.x == x and box.position.y == y
            return box

    return false

@DeleteBoxByID = (id, boxes=@boxes) ->
    for i in [0...boxes.length]
        if boxes[i].boxID is id
            boxes.splice i, 1
            return

@GetByID = (id, boxes=@boxes) ->
    for i in [0...boxes.length]
        if boxes[i].boxID is id
            return boxes[i]
