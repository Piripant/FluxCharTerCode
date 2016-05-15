@saveString = ->
    file_string = ""
    for box in boxes
        file_string += box.name + ";"
        file_string += box.text + ";"
        file_string += box.position.x + ";"
        file_string += box.position.y + ";"
        file_string += box.type + ";"
        file_string += box.boxID + ";"


        if box.prevBox
            file_string += box.prevBox.boxID
        file_string += ";"

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
    try
        file = file_string.split "|"
        for i in [0...file.length]
            file[i] = file[i].split ";"

        for line in file
            box = new Box(line[4])
            box.name = line[0]
            box.setText line[1]
            console.log line[2]
            console.log line[3]
            box.position = new Vector(parseInt(line[2]), parseInt(line[3]))
            box.boxID = parseInt line[5]
            @boxes.push box

        for i in [0...boxes.length]
            if file[i][6] != ""
                boxes[i].prevBox = GetByID(parseInt file[i][6])
            if file[i][7] != ""
                boxes[i].yesBox = GetByID(parseInt file[i][7])
            if file[i][8] != ""
                boxes[i].noBox = GetByID(parseInt file[i][8])
    catch
        alert("File corrupted!")
