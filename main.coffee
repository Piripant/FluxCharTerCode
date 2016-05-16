# TODO: Make possible to delete yesBox and noBox
# TODO: Make save/load functionality
# TODO: Make arrows that connect boxes
# TODO: Write functions index

@IntWorker = null

@onload = ->
    @IntWorker = new Worker("interpreter.js")
    @IntWorker.postMessage ['init']
    @IntWorker.onmessage = workerMessage
    InitCanvas()
    InitHTML()

workerMessage = (event) ->
    switch event.data[0]
        when 'interface' then window.interpreteInterface event.data[1], event.data[2]
