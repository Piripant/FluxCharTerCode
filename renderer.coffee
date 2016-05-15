# TODO: text smart new lines when getting too long, dont cut words in half, maybe wrap after equals

canvas = ''
ctx = ''

selDims = [10, 10]

@boxSize = [105, 79] # This is the grid size, and also the Cmd Size
@cmdEntries = [[boxSize[0]/2, 0], [-boxSize[0]/2, 0], [0, boxSize[1]/2], [0, -boxSize[1]/2]]
@evalSize = [101, 79]
@evalEntries = [[evalSize[0]/2, 0], [-evalSize[0]/2, 0], [0, evalSize[1]/2], [0, -evalSize[1]/2]]
@interSize = [109, 81]
@interEntries = [[interSize[0]/2, 0], [-interSize[0]/2, 0], [0, interSize[1]/2], [0, -interSize[1]/2]]
@gridDist = 25


@InitCanvas = ->
    canvas = document.getElementById('diagr')
    ctx = canvas.getContext("2d")

@RestoreCtx = ->
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    DrawAllBoxes()

@DrawAllBoxes = ->
    console.log boxes
    ctx.beginPath(); # Resets all the stroke settings and paths
    for box in boxes
        DrawBox(box, false)
        DrawText(box.position.x, box.position.y, box.text, false)

    ctx.stroke()
    ctx.beginPath();
    for box in boxes
        if box.yesBox
            DrawConnection(box, box.yesBox, "green", false)

    ctx.stroke()
    ctx.beginPath();
    for box in boxes
        if box.noBox
            DrawConnection(box, box.noBox, "blue", false)

    ctx.stroke()

@DrawConnection = (startBox, endBox, color, single=true) ->
    sx = startBox.position.x
    sy = startBox.position.y
    ex = endBox.position.x
    ey = endBox.position.y

    startPoint = []
    closest_dist = 10000000
    for entry in startBox.entryPoints
        distance = Math.sqrt(Math.pow(entry[0]+sx-ex, 2) + Math.pow(entry[1]+sy-ey, 2))
        console.log [entry[0]+sx, entry[1]+sy]
        if closest_dist > distance
            closest_dist = distance
            startPoint = [entry[0]+sx, entry[1]+sy]

    endPoint = []
    closest_dist = 10000000
    for dest in endBox.entryPoints
        distance = Math.sqrt(Math.pow(dest[0]+ex-startPoint[0], 2) + Math.pow(dest[1]+ey-startPoint[1], 2))
        if closest_dist > distance
            closest_dist = distance
            endPoint = [dest[0]+ex, dest[1]+ey]

    startPoint = new Vector(startPoint[0], startPoint[1])
    endPoint = new Vector(endPoint[0], endPoint[1])
    DrawLine(startPoint, endPoint, startBox, endBox, color, single)


@DrawBox = (box, single=false) ->
    switch box.type
      when cmdName then DrawCmd(box.position.x, box.position.y, single)
      when evalName then DrawEval(box.position.x, box.position.y, single)
      when interName then DrawInter(box.position.x, box.position.y, single)

@DrawCmd = (x, y, single=true) ->
    if single # Only if drawing a single rect
        ctx.beginPath()

    ctx.lineWidth = "2"
    ctx.strokeStyle="#000000"
    ctx.rect(x-boxSize[0]/2, y-boxSize[1]/2, boxSize[0], boxSize[1])

    if single # Only if drawing a single rect
        ctx.stroke()

@DrawEval = (x, y, single) ->
    if single # Only if drawing a single rect
        ctx.beginPath();

    ctx.lineWidth = "2"
    ctx.strokeStyle="#000000"
    ctx.moveTo x, y+interSize[1]/2
    ctx.lineTo x+interSize[0]/2, y
    ctx.lineTo x, y-interSize[1]/2
    ctx.lineTo x-interSize[0]/2, y
    ctx.lineTo x, y+interSize[1]/2

    if single # Only if drawing a single rect
        ctx.stroke()

@DrawInter = (x, y, single) ->
    if single # Only if drawing a single rect
        ctx.beginPath();

    ctx.lineWidth = "2"
    ctx.strokeStyle="#000000"
    ctx.moveTo x+evalSize[0]/2-3, y+evalSize[1]/2
    ctx.lineTo x+evalSize[0]/2+3, y-evalSize[1]/2
    ctx.lineTo x-evalSize[0]/2+3, y-evalSize[1]/2
    ctx.lineTo x-evalSize[0]/2-3, y+evalSize[1]/2
    ctx.lineTo x+evalSize[0]/2-3, y+evalSize[1]/2

    if single # Only if drawing a single rect
        ctx.stroke()

@DrawSelection = (x, y, color="#FF0000") ->
    ctx.beginPath()
    ctx.lineWidth = "2"
    ctx.strokeStyle = color
    ctx.rect(x-boxSize[0]/2-selDims[0]/2, y-boxSize[1]/2-selDims[1]/2, boxSize[0]+selDims[0], boxSize[1]+selDims[1])
    ctx.closePath()
    ctx.stroke()

@DrawText = (x, y, text, single=true) ->
    if single # Only if drawing a single rect
        ctx.beginPath()

    ctx.font = '12px Segoe UI'
    ctx.textAlign = 'center'
    ctx.fillText(text, x, y+12/4, boxSize[0]-4)

    if single # Only if drawing a single rect
        ctx.stroke()


# Has to know about the box position if it wants to connect in a pretty way
@DrawLine = (pos1, pos2, startBox, endBox, color="green", single=true) ->
    if single # Only if drawing a single rect
        ctx.beginPath();

    headlen = 8
    #angle = Math.atan2(pos2.y-pos1.y, pos2.x-pos1.x)
    ctx.lineWidth = "2"
    ctx.strokeStyle = color

    sdisp = (pos1.subtract startBox.position).normalize().mult_num 10
    edisp = (pos2.subtract endBox.position).normalize().mult_num 15

    angle = Math.atan2(-edisp.y, -edisp.x)
    ctx.moveTo pos1.x, pos1.y
    if Math.abs(pos2.x - pos1.x) > Math.abs(pos2.y - pos1.y)
        ctx.lineTo pos1.x+sdisp.x, pos1.y+sdisp.y
        ctx.lineTo pos2.x+edisp.x, pos1.y+sdisp.y
        ctx.lineTo pos2.x+edisp.x, pos2.y+edisp.y
        ctx.lineTo pos2.x, pos2.y
    else
        ctx.lineTo pos1.x+sdisp.x, pos1.y+sdisp.y
        ctx.lineTo pos1.x+sdisp.x, pos2.y+edisp.y
        ctx.lineTo pos2.x+edisp.x, pos2.y+edisp.y
        ctx.lineTo pos2.x, pos2.y


    ctx.lineTo(pos2.x-headlen*Math.cos(angle-Math.PI/6), pos2.y-headlen*Math.sin(angle-Math.PI/6))
    ctx.moveTo pos2.x, pos2.y
    ctx.lineTo(pos2.x-headlen*Math.cos(angle+Math.PI/6), pos2.y-headlen*Math.sin(angle+Math.PI/6))

    if single # Only if drawing a single rect
        ctx.stroke()
