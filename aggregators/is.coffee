module.exports =
    aggregate: (lines, key, buckets) ->
        lastindex = lines.length - 1

        total = 0
        time = 0
        min = Math.min()
        max = Math.max()
        if lines.startvalue?
            t = lines[0].time - lines.starttime
            time += t
            total = lines.startvalue * t
            min = lines.startvalue
            max = lines.startvalue
        for line, i in lines
            nexttime = if i is lastindex then lines.endtime else lines[i + 1].time
            t = (nexttime - line.time)
            time += t
            total += line.value * t
            min = Math.min line.value, min
            max = Math.max line.value, max

        (buckets[key] = []).startvalue = lines[lastindex].value

        starttime: lines.starttime
        endtime: lines.endtime
        firsttime: if lines.startvalue? then lines.starttime else lines[0].time
        firstvalue: if lines.startvalue? then lines.startvalue else lines[0].value
        lastvalue: lines[lastindex].value
        count: lines.length
        min: min
        max: max
        mean: total / time
        time: time
