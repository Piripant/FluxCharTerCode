# TODO: Make possible to delete yesBox and noBox
# TODO: Make save/load functionality
# TODO: Make arrows that connect boxes
# TODO: Write functions index

class HTML_els
    @propID = 'prop'

    @nameID = 'nameInput'
    @commandID = 'cmdInput'
    @nextPropID = 'nextProp'
    @nextYesPropID = 'nextYesProp'
    @nextNoPropID = 'nextNoProp'

    @cmdPropID = 'cmdProp'
    @evalPropID = 'evalProp'
    @interPropID = 'interProp'
    @interCmdID = 'interCmdProp'

@cmdName = 'cmd' # Also used in box type
@evalName = 'eval' # Also used in box type
@interName = 'inter' # Also used in box type
selectName = 'sel'
selYesName = 'selYes'
selNoName = 'selNo'
moveName = 'move'

clickAction = ''
@selectedBox = null

lastID = 0

@onload = ->
    InitCanvas()
    InitHTML()

@InitHTML = ->
    HTML_els.curModeEl = document.getElementById('curMode')
    HTML_els.propEl = document.getElementById(HTML_els.propID)
    HTML_els.nameEl = document.getElementById(HTML_els.nameID)
    HTML_els.commandEl = document.getElementById(HTML_els.commandID)
    HTML_els.nextPropEl = document.getElementById(HTML_els.nextPropID)
    HTML_els.YesPropEl = document.getElementById(HTML_els.nextYesPropID)
    HTML_els.NoPropEl = document.getElementById(HTML_els.nextNoPropID)
    HTML_els.cmdPropEl = document.getElementById(HTML_els.cmdPropID)
    HTML_els.evalPropEl = document.getElementById(HTML_els.evalPropID)
    HTML_els.interPropEl = document.getElementById(HTML_els.interPropID)
    HTML_els.interCmdEl = document.getElementById(HTML_els.interCmdID)

@LoadDia = ->
    @boxes = []
    loadString(document.getElementById("loadInput").value)
    RestoreCtx()

@RunDia = ->
    document.getElementById("saveOutput").value = saveString()
    eraseVars()
    InterpreteBox(@selectedBox)

@StopDia = ->
    stop = true
    alert("The diagram has been stopped")

@SelectType = (type) ->
    switch type
        when 'cmd'
            clickAction = cmdName
            HTML_els.curModeEl.innerHTML = "Add Command"
        when 'eval'
            clickAction = evalName
            HTML_els.curModeEl.innerHTML = "Add Evaluation"
        when 'inter'
            clickAction = interName
            HTML_els.curModeEl.innerHTML = "Add Interface"
        when 'selYes'
            clickAction = selYesName
            if @selectedBox.type == cmdName or @selectedBox.type == interName
                HTML_els.curModeEl.innerHTML = "Select Next Box"
            else
                HTML_els.curModeEl.innerHTML = "Select Yes Box"
        when 'selNo'
            clickAction = selNoName
            HTML_els.curModeEl.innerHTML = "Select No Box"
        when 'move'
            clickAction = moveName
            HTML_els.curModeEl.innerHTML = "Move Box"

# TODO: write a function which changes the gui cursor mode

@OnNameChange = (text) ->
    @selectedBox.name = text

@OnCommandChange = (text) ->
    @selectedBox.setText(text)
    RestoreCtx()
    DrawSelections()

@DeleteSelBox = ->
    DeleteBoxByID(@selectedBox.boxID)
    # Deleting all box references
    if @selectedBox.prevBox # Only if the box was conneted
        if @selectedBox.prevBox.yesBox
            if @selectedBox.prevBox.yesBox.boxID == @selectedBox.boxID
                @selectedBox.prevBox.yesBox = null
            else
                @selectedBox.prevBox.noBox = null
        else
            @selectedBox.prevBox.noBox = null

    @selectedBox = null
    HTML_els.propEl.setAttribute('hidden', '')
    RestoreCtx()

DisableAll = () ->
    HTML_els.cmdPropEl.setAttribute('hidden', '')
    HTML_els.evalPropEl.setAttribute('hidden', '')
    HTML_els.interPropEl.setAttribute('hidden', '')
    HTML_els.interCmdEl.setAttribute('hidden', '')

@CanvasClick = (event) ->
    x = event.offsetX
    y = event.offsetY
    gx = Math.round(x/(boxSize[0]+gridDist))*(boxSize[0]+gridDist)
    gy = Math.round(y/(boxSize[1]+gridDist))*(boxSize[1]+gridDist)

    clickedCell = GetBoxByCoords(gx, gy)
    if clickAction == selYesName or clickAction == selNoName # Selecting next block
        if clickedCell
            if @selectedBox != clickedCell
                if clickAction == selYesName
                    clickAction = selectName
                    @selectedBox.yesBox = clickedCell
                    @selectedBox.yesBox.prevBox = @selectedBox
                else
                    clickAction = selectName
                    @selectedBox.noBox = clickedCell
                    @selectedBox.noBox.prevBox = @selectedBox

                RestoreCtx()
                DrawSelections()

                SetSelectionGUI(@selectedBox)
            else
                alert('Cannot set next as itself!')

        return # To prevent selecting the next block

    else if clickAction == cmdName or clickAction == evalName or clickAction == interName # Adding new block
        if not clickedCell
            # Add differentiation between varius block type
            newBox = new Box(clickAction + "")
            newBox.position = new Vector(gx, gy)
            newBox.name = clickAction + lastID.toString();
            newBox.setText('"Input command"')
            newBox.boxID = lastID
            lastID += 1
            @boxes.push newBox
            clickedCell = newBox
            DrawBox(gx, gy)
        else
            alert('Position already occupied')

    else if clickAction == moveName # Moving the @selectedBox
        if !clickedCell
            @selectedBox.position.x = gx
            @selectedBox.position.y = gy
            RestoreCtx()
            DrawSelections()

        else
            alert('Position already occupied')

        clickAction = selectName # To not stay in moving mode
        HTML_els.curModeEl.innerHTML = "Selecting"
        return # To not select the move position

    clickAction = selectName
    if clickedCell # Selecting a box
        RestoreCtx()
        @selectedBox = clickedCell

        HTML_els.curModeEl.innerHTML = "Selecting"
        HTML_els.propEl.removeAttribute('hidden')
        HTML_els.nameEl.value = @selectedBox.name
        HTML_els.commandEl.value = @selectedBox.text

        SetSelectionGUI(@selectedBox)
        DrawSelections()

        DisableAll()
        switch @selectedBox.type
            when cmdName
                HTML_els.cmdPropEl.removeAttribute('hidden')
                HTML_els.interCmdEl.removeAttribute('hidden')
            when interName
                HTML_els.interPropEl.removeAttribute('hidden')
                HTML_els.interCmdEl.removeAttribute('hidden')
            when evalName then HTML_els.evalPropEl.removeAttribute('hidden')

    else
        RestoreCtx()
        HTML_els.propEl.setAttribute('hidden', '')
        DisableAll()

DrawSelections = ->
    DrawSelection(@selectedBox.position.x, @selectedBox.position.y)
    DrawNexts()

DrawNexts = ->
    if @selectedBox.yesBox
        DrawSelection(@selectedBox.yesBox.position.x, @selectedBox.yesBox.position.y, "green")
        DrawConnection(@selectedBox, @selectedBox.yesBox, "green")
    if @selectedBox.noBox
        DrawSelection(@selectedBox.noBox.position.x, @selectedBox.noBox.position.y, "blue")
        DrawConnection(@selectedBox, @selectedBox.noBox, "blue")

@SetSelectionGUI = (box) ->
    switch box.type
        when cmdName or interName
            if box.yesBox
                HTML_els.nextPropEl.innerHTML = box.yesBox.name
            else
                HTML_els.nextPropEl.innerHTML = '...'
        when evalName
            if box.yesBox
                HTML_els.YesPropEl.innerHTML = box.yesBox.name
            else
                HTML_els.YesPropEl.innerHTML = '...'
            if box.noBox
                HTML_els.NoPropEl.innerHTML = box.noBox.name
            else
                HTML_els.NoPropEl.innerHTML = '...'
