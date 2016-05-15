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

selectName = 'sel'
selYesName = 'selYes'
selNoName = 'selNo'
moveName = 'move'

clickAction = ''
@selectedBox = null
lastID = 0

@LoadDia = ->
    @boxes = []
    loadString(document.getElementById("loadInput").value)
    RestoreCtx()

@RunDia = ->
    document.getElementById("saveOutput").value = saveString()
    @IntWorker.postMessage ['eraseVars']
    @IntWorker.postMessage ['interprete', @selectedBox]

@StopDia = ->
    stop = true
    swal("The diagram has been stopped")

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
    if @selectedBox.prevBoxes.length > 0 # Only if the box was conneted
        for i in [0...@selectedBox.prevBoxes.length]
            prevBox = @selectedBox.prevBoxes[i]
            if prevBox.yesBox
                if prevBox.yesBox.boxID == @selectedBox.boxID
                    @selectedBox.prevBoxes[i].yesBox = null
                else
                    @selectedBox.prevBoxes[i].noBox = null
            else
                @selectedBox.prevBoxes[i].noBox = null

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
                console.log clickAction
                if clickAction is selYesName
                    console.log @selectedBox.yesBox isnt clickedCell
                    if @selectedBox.yesBox isnt clickedCell # It is already the yesBox
                        selectedBox.yesBox = clickedCell
                        @selectedBox.yesBox.prevBoxes.push @selectedBox
                else
                    if @selectedBox.noBox isnt clickedCell
                        @selectedBox.noBox = clickedCell
                        console.log @selectedBox.noBox
                        @selectedBox.noBox.prevBoxes.push @selectedBox

                clickAction = selectName
                RestoreCtx()
                DrawSelections()

                SetSelectionGUI(@selectedBox)
            else
                swal('Cannot set next as itself!')

        return # To prevent selecting the next block

    else if clickAction == cmdName or clickAction == evalName or clickAction == interName # Adding new block
        if not clickedCell
            # Add differentiation between varius block type
            newBox = new Box(clickAction + "")
            newBox.position = new Vector(gx, gy)
            newBox.name = clickAction + lastID.toString();
            if newBox.type isnt interName
                newBox.setText('"Input command"')
            else
                newBox.setText('output("Hello!")')
            newBox.boxID = lastID
            lastID += 1
            @boxes.push newBox
            clickedCell = newBox
            DrawBox(gx, gy)
        else
            swal('Position already occupied')

    else if clickAction == moveName # Moving the @selectedBox
        if !clickedCell
            @selectedBox.position.x = gx
            @selectedBox.position.y = gy
            RestoreCtx()
            DrawSelections()

        else
            swal('Position already occupied')

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
    if box.type is cmdName or box.type is interName
        if box.yesBox
            HTML_els.nextPropEl.innerHTML = box.yesBox.name
        else
            HTML_els.nextPropEl.innerHTML = '...'
    else
        if box.yesBox
            HTML_els.YesPropEl.innerHTML = box.yesBox.name
        else
            HTML_els.YesPropEl.innerHTML = '...'
        if box.noBox
            HTML_els.NoPropEl.innerHTML = box.noBox.name
        else
            HTML_els.NoPropEl.innerHTML = '...'
