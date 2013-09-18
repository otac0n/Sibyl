module.exports = 
    aggregate: (lines) ->
        starttime: lines.starttime
        endtime: lines.endtime
        times: line.time for line in lines
