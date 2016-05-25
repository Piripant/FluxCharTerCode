vars_dict = {}

running = false
stop = false
lastNextBox = null

@onmessage = (event) ->
    switch event.data[0]
        when 'init' then init()
        when 'eraseVars' then eraseVars()
        when 'interprete' then InterpreteBox event.data[1]
        when 'resume' then ResumeInterpreter()
        when 'interResponse' then interfaceResponse event.data[1]
        when 'stop' then StopInterpreter()

init = ->
    importScripts 'crossWorkerData.js'

eraseVars = ->
    vars_dict = {}

interfaceResponse = (vars) ->
    vars_dict = vars
    ResumeInterpreter()

ResumeInterpreter = ->
    if lastNextBox
        InterpreteBox(lastNextBox)

StopInterpreter = ->
    if running
        stop = true

InterpreteBox = (startBox) ->
    running = true

    if not startBox
        postMessage ['interface', "intprtAlert('Please select a starting box!')", vars_dict]
        running = false

    if not stop
        try
            if startBox.type is cmdName
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

            else if startBox.type is evalName
                if eval startBox.compText
                    if startBox.yesBox
                        InterpreteBox(startBox.yesBox)
                else
                    if startBox.noBox
                        InterpreteBox(startBox.noBox)
            else
                if startBox.yesBox
                    InterpreteBox(startBox.yesBox)

        catch ex
            postMessage ['interface', "intprtAlert('An execution error was raised! See console for details')", vars_dict]
            console.log ex
            running = false

    else
        postMessage ['interface', "intprtAlert('Diagram has been stopped')", vars_dict]
        stop = false
        running = false
