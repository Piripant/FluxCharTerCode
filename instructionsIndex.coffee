functions_index = {
    "pi": "The constant of PI",
    "sin": "The sine of an angle",
    "cos": "The cosine of an angle",
    "tan": "The tangent of an angle",
    "abs": "The absolute value of a variable",
    "mod": "The module operator",
    "^": "The power operator",
    "input": "Prompts the user to input data",
    "output": "Prints the data"
}

# When there will be too many functions a swal wont be enoght, and maybe a separate page should be done
@PrintInstuctions = ->
    indexstr = ""
    for key in Object.keys(functions_index)
        console.log key
        indexstr += key + " => " + functions_index[key] + "\n"
    console.log indexstr
    swal("Here is a list of all functions", indexstr)
