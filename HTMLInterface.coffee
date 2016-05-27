class HTML_els
    @propClass = 'prop'
    @genPropID = 'generalProp'

    @nameID = 'nameInput'
    @commandID = 'cmdInput'
    @nextPropID = 'nextProp'
    @delNextID = 'delNext'
    @nextYesPropID = 'nextYesProp'
    @delYesID = 'delYes'
    @nextNoPropID = 'nextNoProp'
    @delNoID = 'delNo'

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
lastID = 2

@InitHTML = ->
    HTML_els.curModeEl = document.getElementById 'curMode'
    HTML_els.propEl = document.getElementsByClassName HTML_els.propClass # Array
    HTML_els.genPropEl = document.getElementsByClassName HTML_els.genPropID
    HTML_els.nameEl = document.getElementById HTML_els.nameID
    HTML_els.commandEl = document.getElementById HTML_els.commandID
    HTML_els.nextPropEl = document.getElementById HTML_els.nextPropID
    HTML_els.delNextEl = document.getElementById HTML_els.delNextID
    HTML_els.YesPropEl = document.getElementById HTML_els.nextYesPropID
    HTML_els.delYesEl = document.getElementById HTML_els.delYesID
    HTML_els.NoPropEl = document.getElementById HTML_els.nextNoPropID
    HTML_els.delNoEl = document.getElementById HTML_els.delNoID
    HTML_els.cmdPropEl = document.getElementById HTML_els.cmdPropID
    HTML_els.evalPropEl = document.getElementById HTML_els.evalPropID
    HTML_els.interPropEl = document.getElementById HTML_els.interPropID
    HTML_els.interCmdEl = document.getElementById HTML_els.interCmdID

    document.getElementById('diagr').onselectstart = -> return false
    document.getElementById('diagr').onmousemove = CanvasDrag
    document.getElementById('diagr').onmouseup = CanvasUp
    document.onmouseup = DocumentUp

#############################################################

 ####    ##   #      #      #####    ##    ####  #    #  ####
#    #  #  #  #      #      #    #  #  #  #    # #   #  #
#      #    # #      #      #####  #    # #      ####    ####
#      ###### #      #      #    # ###### #      #  #        #
#    # #    # #      #      #    # #    # #    # #   #  #    #
 ####  #    # ###### ###### #####  #    #  ####  #    #  ####

##############################################################

@SaveDia = ->
    text = saveString()
    swal({title: "Here is your save", html:"<span>(double click to copy)</span><br><br><textarea rows=20 cols=50 readonly=true style=\"resize:none\">" + text + "</textarea>"})

@LoadDia = ->
    swal({title: "Input save file", input: 'text', inputPlaceholder: "Your input here"}).then(loadClick)

loadClick = (text) ->
    if text isnt ""
        loadString(text)
        RestoreCtx()

@RunDia = ->
    @IntWorker.postMessage ['eraseVars']
    @IntWorker.postMessage ['interprete', @boxes[0]]

@StopDia = ->
    @IntWorker.postMessage ['stop']

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

@DeleteNext = (type) ->
    if type is 'yes'
        @selectedBox.yesBox = null
    else
        @selectedBox.noBox = null

    SetSelectionGUI(@selectedBox)
    RestoreCtx()
    DrawSelections()

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
                if prevBox.yesBox.boxID is @selectedBox.boxID
                    @selectedBox.prevBoxes[i].yesBox = null
                else
                    @selectedBox.prevBoxes[i].noBox = null
            else
                @selectedBox.prevBoxes[i].noBox = null

    if @selectedBox.yesBox
        for i in [0...@selectedBox.yesBox.prevBoxes.length]
            prevBox = @selectedBox.yesBox.prevBoxes[i]
            if prevBox.boxID is @selectedBox.boxID
                @selectedBox.yesBox.prevBoxes.splice i, 1
    if @selectedBox.noBox
        for i in [0...@selectedBox.noBox.prevBoxes.lenght]
            prevBox = @selectedBox.noBox.prevBoxes[i]
            if prevBox.boxID is @selectedBox.boxID
                @selectedBox.noBox.prevBoxes.splice i, 1

    @selectedBox = null
    clickAction = selectName
    SelectType(clickAction)
    HideAllEl(HTML_els.propEl)
    HideAllEl(HTML_els.genPropEl)
    DisableAll()
    RestoreCtx()

##########################################################

#    # ##### #    # #         #    # ##### # #       ####
#    #   #   ##  ## #         #    #   #   # #      #
######   #   # ## # #         #    #   #   # #       ####
#    #   #   #    # #         #    #   #   # #           #
#    #   #   #    # #         #    #   #   # #      #    #
#    #   #   #    # ######     ####    #   # ######  ####

##########################################################

DisableAll = ->
    HTML_els.cmdPropEl.setAttribute('hidden', '')
    HTML_els.evalPropEl.setAttribute('hidden', '')
    HTML_els.interPropEl.setAttribute('hidden', '')
    HTML_els.interCmdEl.setAttribute('hidden', '')

HideAllEl = (el_arr) ->
    for i in [0...el_arr.length]
        el_arr[i].setAttribute('hidden', '')

ShowAllEl = (el_arr) ->
    for i in [0...el_arr.length]
        el_arr[i].removeAttribute('hidden')

HTML_SetAttributes = (box) ->
    HTML_els.curModeEl.innerHTML = "Selecting"
    if box.type is 'start' or box.type is 'end'
        HideAllEl(HTML_els.propEl)
    else
        ShowAllEl(HTML_els.propEl)
        HTML_els.nameEl.value = box.name
        HTML_els.commandEl.value = box.text


    ShowAllEl(HTML_els.genPropEl)
    DisableAll()
    if box.type is cmdName
        HTML_els.cmdPropEl.removeAttribute('hidden')
        HTML_els.interCmdEl.removeAttribute('hidden')

    else if box.type is interName
        HTML_els.interPropEl.removeAttribute('hidden')
        HTML_els.interCmdEl.removeAttribute('hidden')

    else if box.type is evalName
        HTML_els.evalPropEl.removeAttribute('hidden')

    else if box.type is 'start'
        HTML_els.interCmdEl.removeAttribute('hidden')

@SetSelectionGUI = (box) ->
    if box.type is cmdName or box.type is interName or box.type is 'start'
        if box.yesBox
            HTML_els.nextPropEl.innerHTML = box.yesBox.name
            HTML_els.delNextEl.removeAttribute('hidden')
        else
            HTML_els.nextPropEl.innerHTML = '...'
            HTML_els.delNextEl.setAttribute('hidden', '')
    else
        if box.yesBox
            HTML_els.YesPropEl.innerHTML = box.yesBox.name
            HTML_els.delYesEl.removeAttribute('hidden')
        else
            HTML_els.YesPropEl.innerHTML = '...'
            HTML_els.delYesEl.setAttribute('hidden', '')
        if box.noBox
            HTML_els.NoPropEl.innerHTML = box.noBox.name
            HTML_els.delNoEl.removeAttribute('hidden')
        else
            HTML_els.NoPropEl.innerHTML = '...'
            HTML_els.delNoEl.setAttribute('hidden', '')

#########################################

 ####    ##   #    # #    #   ##    ####
#    #  #  #  ##   # #    #  #  #  #
#      #    # # #  # #    # #    #  ####
#      ###### #  # # #    # ######      #
#    # #    # #   ##  #  #  #    # #    #
 ####  #    # #    #   ##   #    #  ####

#########################################

isMouseDown = false

@CanvasUp = (event) ->
    isMouseDown = false

@DocumentUp = (event) ->
    isMouseDown = false

@CanvasDrag = (event) ->
    if selectedBox and isMouseDown
        x = event.offsetX
        y = event.offsetY
        gx = Math.round(x/(boxSize[0]+gridDist))*(boxSize[0]+gridDist)
        gy = Math.round(y/(boxSize[1]+gridDist))*(boxSize[1]+gridDist)

        overingCell = GetBoxByCoords(gx, gy)
        if not overingCell
            selectedBox.position.x = gx
            selectedBox.position.y = gy
            RestoreCtx()
            DrawSelections()

@CanvasClick = (event) ->
    isMouseDown = true

    x = event.offsetX
    y = event.offsetY
    gx = Math.round(x/(boxSize[0]+gridDist))*(boxSize[0]+gridDist)
    gy = Math.round(y/(boxSize[1]+gridDist))*(boxSize[1]+gridDist)

    clickedCell = GetBoxByCoords(gx, gy)
    if clickAction == selYesName or clickAction == selNoName # Selecting next block
        if clickedCell
            if @selectedBox != clickedCell and clickedCell.type isnt 'start'
                if clickAction is selYesName
                    if @selectedBox.yesBox isnt clickedCell # It is already the yesBox
                        @selectedBox.yesBox = clickedCell
                        @selectedBox.yesBox.prevBoxes.push @selectedBox
                else
                    if @selectedBox.noBox isnt clickedCell
                        @selectedBox.noBox = clickedCell
                        @selectedBox.noBox.prevBoxes.push @selectedBox

                RestoreCtx()
                DrawSelections()
                SetSelectionGUI(@selectedBox)
            else
                HTML_els.curModeEl.innerHTML = 'Selecting'
                swal('Cannot set next as itself or start!')

        clickAction = selectName
        HTML_els.curModeEl.innerHTML = 'Selecting'
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
        if not clickedCell
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
    console.log clickedCell
    if clickedCell # Selecting a box
        RestoreCtx()
        @selectedBox = clickedCell

        HTML_SetAttributes(@selectedBox)
        SetSelectionGUI(@selectedBox)
        DrawSelections()

    else
        @selectedBox = null
        RestoreCtx()
        HideAllEl(HTML_els.propEl)
        HideAllEl(HTML_els.genPropEl)
        DisableAll()

    return # To prevent text highlighting

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
