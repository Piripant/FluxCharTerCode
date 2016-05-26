@saveString = ->
    file_string = ""
    for box in boxes
        file_string += box.name + ";"
        file_string += box.text + ";"
        file_string += box.position.x + ";"
        file_string += box.position.y + ";"
        file_string += box.type + ";"
        file_string += box.boxID + ";"

        if box.yesBox
            file_string += box.yesBox.boxID
        file_string += ";"

        if box.noBox
            file_string += box.noBox.boxID
        file_string += ";"

        file_string += "|"

    file_string = file_string.slice 0, file_string.length-1 # To remove the last \n
    return file_string

@loadString = (file_string) ->
    newBoxes = []
    try
        file = file_string.split "|"
        for i in [0...file.length]
            file[i] = file[i].split ";"

        for line in file
            box = new Box(line[4])
            box.name = line[0]
            box.setText line[1]
            box.position = new Vector(parseInt(line[2]), parseInt(line[3]))
            box.boxID = parseInt line[5]
            newBoxes.push box

        for i in [0...boxes.length]
            if file[i][6] != ""
                newBoxes[i].yesBox = GetByID(parseInt file[i][6])
                newBoxes[i].yesBox.prevBoxes.push boxes[i]
            if file[i][7] != ""
                newBoxes[i].noBox = GetByID(parseInt file[i][7])
                newBoxes[i].noBox.prevBoxes.push boxes[i]

        @boxes = newBoxes

    catch ex
        swal("File corrupted!")
        InitForms()
        console.log ex
