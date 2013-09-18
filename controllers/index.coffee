index = (req, res) ->
    res.send 'hello'

exports.init = (app) ->
    app.get('/', index)
