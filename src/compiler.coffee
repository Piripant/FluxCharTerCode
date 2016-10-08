# All math's functions
math_funcs = {"pi": "Math.PI", "sin": "Math.sin", "cos": "Math.cos", "tan": "Math.tan", "abs": "Math.abs", "mod": "%", "^": "**"}
inter_funcs = {"input": "intprtPrompt", "output": "intprtAlert"}
eval_funcs = {"=": "=="}
ignore = ["=", "-", "+", "*", "/", "\'", "\"", "(", ")", "<", ">"] # Things that don't have to be translated
starts = ["\"", "\'"]

# To search between two chars: char[\s\S]*?char
scopes_exps = "(\'[\\s\\S]*?\')|(\"[\\s\\S]*?\")"
normal_seps = "\\s|(\\*)|(\\-)|(\\+)|(\\/)|(\")|(\')|(\\=)|(\\^)|(\\()|(\\))|(\\<)|(\\>)"  # TODO: Derive from ignore and trans lists
separators = new RegExp(scopes_exps + "|" + normal_seps)

@compile = (text, type) ->
    exps = text.split separators

    i = 0
    while i < exps.length
        if exps[i] is undefined or exps[i] is ""
            exps.splice i, 1
        else
            i += 1

    hasInterface = false
    inter_keys = Object.keys(inter_funcs)
    trans_dict = Object.assign(math_funcs, inter_funcs)
    
    # Extend the dictionary to eval_funcs if its eval
    if type is evalName
        trans_dict = Object.assign(trans_dict, eval_funcs)
    
    # All the key_words and functions available to this box's type
    trans_keys = Object.keys(trans_dict)

    for i in [0...exps.length]
        exp = exps[i]
        if exp in trans_keys # It is a function
            if exp in inter_keys
                hasInterface = true
                # If there is an interface function call in a non inteface box
                if type isnt interName
                    swal("Error during compilation", "An interface function was found in this non interface box.\nChange the box's text")
                    return

            exps[i] = trans_dict[exp]

        else if exp not in ignore and exp[0] not in starts and isNaN exp # It is a var
            exps[i] = "vars_dict[\"" + exp + "\"]"

    # If there is no interface function call in this interface box
    if type is interName and not hasInterface
        swal("Error during compilation", "There is no interface function in this interface box.\nChange the box's text")

    result = exps.join("")
    return result
