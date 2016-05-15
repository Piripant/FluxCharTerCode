vars_dict = {}

stop = false
lastNextBox = null

@onmessage = (event) ->
    console.log event.data
    switch event.data[0]
        when 'init' then init()
        when 'eraseVars' then eraseVars()
        when 'interprete' then InterpreteBox event.data[1]
        when 'resume' then ResumeInterpreter()
        when 'interResponse' then interfaceResponse event.data[1]

init = ->
    importScripts 'crossWorkerData.js'

eraseVars = ->
    vars_dict = {}

interfaceResponse = (vars) ->
    console.log "Reciving response"
    console.log vars
    vars_dict = vars
    ResumeInterpreter()

ResumeInterpreter = () ->
    console.log lastNextBox
    if lastNextBox
        InterpreteBox(lastNextBox)

InterpreteBox = (startBox) ->
    if not startBox
        postMessage ['interface', "intprtAlert('Please select a starting box!')"]

    if not stop
        try
            if startBox.type is cmdName
                console.log "Next!"
                eval startBox.compText
                if startBox.yesBox
                    InterpreteBox(startBox.yesBox)

            else if startBox.type is interName
                postMessage ['interface', startBox.compText, vars_dict]
                if startBox.yesBox
                    lastNextBox = startBox.yesBox
                else
                    lastNextBox = null

                return

            else
                if eval startBox.compText
                    if startBox.yesBox
                        InterpreteBox(startBox.yesBox)
                else
                    if startBox.noBox
                        InterpreteBox(startBox.noBox)

        catch ex
            postMessage ['interface', "intprtAlert('An execution error was raised! See console for details')"]
            console.log ex

    else
        stop = false
