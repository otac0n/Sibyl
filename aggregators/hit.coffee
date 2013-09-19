module.exports = 
    aggregate: (lines) ->
        total = 0
        for line in lines
            total += line.value
        starttime: lines.starttime
        endtime: lines.endtime
        count: total
    combine: (chunks, starttime, endtime) ->
        weight = (s, e) -> ((if e < endtime then e else endtime) - (if s > starttime then s else starttime)) / (e - s)

        count = 0
        for chunk in chunks
            count += chunk.count * weight chunk.starttime, chunk.endtime

        starttime: starttime
        endtime: endtime
        count: count
