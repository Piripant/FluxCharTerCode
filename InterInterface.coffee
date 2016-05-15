# TODO: make the onSwalInput work as a normal prompt (find the fucntion call and replace it with the result, and finally rievaluate the string)
promptRegex = /intprtPrompt\([\s\S]*?\)/

vars_dict = {}
inputType = ''

@interpreteInterface = (code, vars) ->
    console.log vars
    vars_dict = vars
    eval code

intprtAlert = (text) ->
    swal({title: text.toString(), animation: "none", allowEscapeKey: false}, onSwalClick)

intprtPrompt = (text) ->
    swal({title: text.toString(), animation: "none", allowEscapeKey: false, type: "input", inputPlaceholder: "Your input here"}, onSwalInput)

onSwalInput = (input_text) ->
    setTimeout resumeMessage, 700
    return input_text

onSwalClick = ->
    setTimeout resumeMessage, 700

resumeMessage = ->
    IntWorker.postMessage ['interResponse', vars_dict]
