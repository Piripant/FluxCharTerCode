# TODO: Make possible to delete yesBox and noBox
# TODO: Write functions index


@IntWorker = null

@onload = ->
    @IntWorker = new Worker("interpreter.js")
    @IntWorker.postMessage ['init']
    @IntWorker.onmessage = workerMessage
    InitForms()
    InitCanvas()
    InitHTML()
    DrawAllBoxes()

workerMessage = (event) ->
    switch event.data[0]
        when 'interface' then window.interpreteInterface event.data[1], event.data[2]
