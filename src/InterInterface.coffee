# TODO: make the onSwalInput work as a normal prompt (find the fucntion call and replace it with the result, and finally rievaluate the string)
promptRegex = /intprtPrompt\([\s\S]*?\)/
replaceRegex = /\"|\'/

vars_dict = {}
inputType = ''

eval_code = ""

@interpreteInterface = (code, vars) ->
    vars_dict = vars
    eval_code = code
    eval code

intprtAlert = (text_message) ->
    swal({title: text_message.toString(), animation: "none", allowEscapeKey: false}).then(onSwalClick)

intprtPrompt = (text_message) ->
    swal({title: text_message.toString(), animation: "none", allowEscapeKey: false, input: 'textarea', showCancelButton: false}).then(
        (text) ->
            onSwalInput(text)
    )

onSwalInput = (input_text) ->    
    if isNaN input_text
        # Escape all the strange charaters
        input_text = input_text.replace(/["'-[\]{}()*+?.,\\^$|#\s]/g, "\\$&")
        eval_code = eval_code.replace(promptRegex, "\"" + input_text + "\"")
    else
        eval_code = eval_code.replace(promptRegex, input_text)
    
    # Evaluate the new code
    eval eval_code

    setTimeout resumeMessage, 500

onSwalClick = ->
    setTimeout resumeMessage, 500

resumeMessage = ->
    IntWorker.postMessage ['interResponse', vars_dict]
