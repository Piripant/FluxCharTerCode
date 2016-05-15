@saveString = ->
    file_string = ""
    for box in boxes
        file_string += box.name + ";"
        file_string += box.text + ";"
        file_string += box.position.x + ";"
        file_string += box.position.y + ";"
        file_string += box.type + ";"
        file_string += box.boxID + ";"


        if box.prevBoxes.length > 0
            for prevBox in box.prevBoxes
                console.log prevBox
                file_string += prevBox.boxID + "."
            file_string = file_string.slice 0, file_string.length-1
        file_string += ".;"

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
            box.position = new Vector(parseInt(line[2]), parseInt(line[3]))
            box.boxID = parseInt line[5]
            @boxes.push box

        for i in [0...boxes.length]
            if file[i][6] != ""
                file[i][6] = file[i][6].split(".")
                for boxID in file[i][6]
                    if boxID isnt ""
                        boxes[i].prevBoxes.push GetByID(parseInt boxID)
            if file[i][7] != ""
                boxes[i].yesBox = GetByID(parseInt file[i][7])
            if file[i][8] != ""
                boxes[i].noBox = GetByID(parseInt file[i][8])

            console.log file[i]
        console.log boxes
    catch
        alert("File corrupted!")
