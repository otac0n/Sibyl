graph = (req, res) ->
    res.setHeader('Content-Type', 'image/svg+xml')
    res.send '<svg xmlns="http://www.w3.org/2000/svg" version="1.0"></svg>'

exports.init = (app) ->
    app.get('/graph', graph)
