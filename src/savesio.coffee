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
    swal({title: "Loading", showConfirmButton: false})
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
            @lastID = box.boxID + 1
            newBoxes.push box

        for i in [0...newBoxes.length]
            if file[i][6] != ""
                newBoxes[i].yesBox = GetByID(parseInt(file[i][6]), newBoxes)
                newBoxes[i].yesBox.prevBoxes.push newBoxes[i]
            if file[i][7] != ""
                newBoxes[i].noBox = GetByID(parseInt(file[i][7]), newBoxes)
                newBoxes[i].noBox.prevBoxes.push newBoxes[i]

        @boxes = newBoxes

    catch ex
        swal("File corrupted!")
        console.log ex

    finally
        swal.close()
