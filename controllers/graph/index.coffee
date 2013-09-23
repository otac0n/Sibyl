lib = require '../../lib'
metricPattern = /^([-_A-Za-z0-9.]+)\/(is|took|hit|happened)$/

graph = (req, res) ->
    match = metricPattern.exec req.query.metric
    if not match?
        res.send 400, 'invalid metric'
        return

    type = match[2]
    name = match[1]
    options =
        width: 600
        height: 400
        palette: [
            '#e69f00'
            '#56b4e9'
            '#2b9f78'
            '#f0e442'
            '#0072b2'
            '#d55e00'
            '#cc79a7'
        ]
        percentiles: [0.01, 0.1, 0.5, 0.9, 0.99]
        includeZero: false

    now = new Date()
    startdate = req.query.start || "-1day"
    enddate = req.query.end || "0day"

    starttime = (lib.dateParse now, startdate).getTime()
    endtime = (lib.dateParse now, enddate).getTime()

    lib.serializer.read "#{type}-#{name}", starttime, endtime, (err, chunks) ->
        if err then throw err

        result = lib.aggregators[type].combine chunks, starttime, endtime
        lib.aggregators[type].addPercentiles result, options.percentiles

        res.setHeader 'Content-Type', 'image/svg+xml'
        res.render 'graph/views/histogram', { data: result, options: options }

exports.init = (app) ->
    app.get('/graph', graph)
