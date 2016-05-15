# Add all math's functions
math_funcs = {"pi": "Math.PI", "sin": "Math.sin", "cos": "Math.cos", "tan": "Math.tan", "abs": "Math.abs", "mod": "%", "^": "**"}
inter_funcs = {"input": "prompt", "output": "intprtAlert"}
trans = Object.assign(math_funcs, inter_funcs) # You can create a copy using Object.assign if you dont want the dictionaries being modified
ignore = ["=", "-", "+", "*", "/", "\'", "\"", "(", ")", "<", ">"] # Things that don't have to be translated
starts = ["\"", "\'"]

# To search between two chars: char[\s\S]*?char
scopes_exps = "(\'[\\s\\S]*?\')|(\"[\\s\\S]*?\")"
normal_seps = "\\s|(\\*)|(\\-)|(\\+)|(\\/)|(\")|(\')|(\\=)|(\\^)|(\\()|(\\))|(\\<)|(\\>)"  # TODO: Derive from ignore and trans lists
separators = new RegExp(scopes_exps + "|" + normal_seps)

vars_dict = {}

@compile = (text, type) ->
    exps = text.split separators

    i = 0
    while i < exps.length
        if exps[i] is undefined or exps[i] is ""
            exps.splice i, 1
        else
            i += 1

    trans_keys = Object.keys(trans)
    for i in [0...exps.length]
        exp = exps[i]
        # TODO:
        if exp in trans_keys # It is a function
            exps[i] = trans[exp]

        # TODO: covert = to == in evaluation boxes
        else if exp not in ignore and exp[0] not in starts and isNaN exp # It is a var
            exps[i] = "vars_dict[\"" + exp + "\"]"

    result = exps.join("")
    return result

@eraseVars = ->
    vars_dict = {}

# TODO: pause ability
# TODO: to pause must do in web worker
@stop = false
@InterpreteBox = (startBox) ->
    if not @stop
        try
            if startBox.type is cmdName or startBox.type is interName
                console.log "Here!"
                eval startBox.compText
                if startBox.yesBox # TODO: use id to identify infinite recursion
                    InterpreteBox(startBox.yesBox)

            #TODO: alert functions must pose the code execution
            else
                if eval startBox.compText
                    if startBox.yesBox
                        InterpreteBox(startBox.yesBox)
                else
                    if startBox.noBox
                        InterpreteBox(startBox.noBox)

        catch ex
            alert("An execution error was raised, see console for more details")
            console.log ex
    else
        @stop = false
