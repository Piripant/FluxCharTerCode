tutorial_string = 'Start;Start;130;104;start;0;;;|End;End;130;728;end;1;;;|The name is optional;"Press on this to select";130;208;cmd;2;4;;|The name is optional;"Here you can type a command";390;208;cmd;3;;;|The name is optional;"Drag box to move";260;208;cmd;4;3;;|The name is optional;output("Hello!");260;312;inter;6;12;;|The name is optional;"This is used for output";130;312;cmd;7;6;;|The name is optional;"This is used for input";130;416;cmd;8;13;;|The name is optional;output(var);390;312;inter;12;;;|The name is optional;var = input("prompt");260;416;inter;13;;;|cmd14;"The start box is where";130;624;cmd;14;15;;|cmd15;"the diagram starts";260;624;cmd;15;;;|The name is optional;"This is used for evaluation";130;520;cmd;16;17;;|An Evaluation Box;a_var < 10;260;520;eval;17;18;19;|Less than 10;"The var is less than 10";520;416;cmd;18;;;|More than 10;"The var is bigger than 10";520;624;cmd;19;;;|cmd20;"You can assign vars";780;208;cmd;20;21;;|cmd21;var = 100;910;208;cmd;21;22;;|cmd22;var = "Ciao";910;312;cmd;22;23;;|cmd23;var = sin(10);910;416;cmd;23;;;|cmd24;"You can use many functions";780;520;cmd;24;25;;|cmd25;"Check \'print index\'!";910;520;cmd;25;;;'

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
        indexstr += key + " => " + functions_index[key] + "\n"
    swal("Here is a list of all functions", indexstr)

@LoadTutorial = ->
    loadString(tutorial_string)
    RestoreCtx()
