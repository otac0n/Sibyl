fs = require 'fs'
aggregators =
    is: require '../../aggregators/is'
    took: require '../../aggregators/took'
    hit: require '../../aggregators/hit'
    happened: require '../../aggregators/happened'
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

    fs.readFile "./data/#{type}-#{name}", { encoding: 'UTF8'}, (err, data) ->
        if err then throw err

        chunks = []
        chunkPattern = /\x0F([^\x0F\x0E]+)\x0E/g
        while (m = chunkPattern.exec data) != null
            chunks.push JSON.parse m[1]

        result = aggregators[type].combine chunks, starttime, endtime

        res.setHeader 'Content-Type', 'image/svg+xml'
        res.render 'graph/views/histogram', { data: result, options: options }

exports.init = (app) ->
    app.get('/graph', graph)
