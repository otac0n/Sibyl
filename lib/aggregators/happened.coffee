module.exports = 
    aggregate: (lines) ->
        starttime: lines.starttime
        endtime: lines.endtime
        times: line.time for line in lines
    combine: (chunks, starttime, endtime) ->
        times = (chunk.times for chunk in chunks)
        times = [].concat times...

        starttime: starttime
        endtime: endtime
        times: t for t in times when t >= starttime and t < endtime
