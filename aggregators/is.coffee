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
    combine: (chunks, starttime, endtime) ->
        filtered = (chunk for chunk in chunks when chunk.starttime < endtime and chunk.endtime > starttime)
        filtered.sort (a, b) -> a.starttime - b.starttime

        weight = (s, e) -> ((if e < endtime then e else endtime) - (if s > starttime then s else starttime)) / (e - s)

        firsttime = null
        firstvalue = null
        lastvalue = null
        count = 0
        min = null
        max = null
        total = 0
        time = 0
        for chunk in filtered
            if not firsttime?
                firsttime = Math.max chunk.firsttime, starttime
                if chunk.firsttime >= starttime
                    firstvalue = chunk.firstvalue
                min = chunk.min
                max = chunk.max
            else
                min = Math.min min, chunk.min
                max = Math.max max, chunk.max

            if chunk.endtime >= endtime
                lastvalue = chunk.lastvalue
            w = weight chunk.starttime, chunk.endtime
            count += chunk.count * w
            time += chunk.time * w
            total += chunk.mean * chunk.time * w

        starttime: starttime
        endtime: endtime
        firsttime: firsttime
        firstvalue: firstvalue
        lastvalue: lastvalue
        count: count
        min: min
        max: max
        mean: total / time
        time: time
