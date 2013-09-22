lib = require '../../lib'
metricPattern = /^([-_A-Za-z0-9.]+)\/(is|took|hit|happened)$/
datePattern = /^([-+]?\d+)(second|minute|hour|day|month|year)s?$/

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

    dateParse = (now, s) ->
        match = datePattern.exec s
        if not match?
            # try to parse as a literal date
            return null
        date = new Date(now)
        diff = +match[1]
        switch match[2]
            when 'second' then date.setSeconds date.getSeconds() + diff
            when 'minute' then date.setMinutes date.getMinutes() + diff
            when 'hour' then date.setHours date.getHours() + diff
            when 'day' then date.setDate date.getDate() + diff
            when 'month' then date.setMonth date.getMonth() + diff
            when 'year' then date.setYear date.getYear() + diff
        return date

    now = new Date()
    startdate = req.query.start || "-1day"
    enddate = req.query.end || "0day"

    starttime = (dateParse now, startdate).getTime()
    endtime = (dateParse now, enddate).getTime()

    lib.serializer.read "#{type}-#{name}", starttime, endtime, (err, chunks) ->
        if err then throw err

        result = lib.aggregators[type].combine chunks, starttime, endtime
        lib.aggregators[type].addPercentiles result, options.percentiles

        res.setHeader 'Content-Type', 'image/svg+xml'
        res.render 'graph/views/histogram', { data: result, options: options }

exports.init = (app) ->
    app.get('/graph', graph)
