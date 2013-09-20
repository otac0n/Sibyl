makehistogram = (binsize = 0) ->
    binsize: binsize
    length: 0

pushhistogram = (histogram, value, count) ->
    bin = if histogram.binsize is 0 then value else Math.floor(value / histogram.binsize) * histogram.binsize
    if not histogram[bin]?
        histogram.length += 1
        histogram[bin] = count
        if histogram.length > 32
            newbinsize =
                if histogram.binsize == 0
                    bins = (k for k, v of histogram when k not in ['binsize', 'length'])
                    bins.sort (a, b) -> a - b
                    size = Math.min()
                    for i in [1...bins.length]
                        size = Math.min bins[i] - bins[i - 1], size
                    Math.pow 2, Math.max Math.floor(Math.log(size) / Math.LN2) + 1, -19 # Smallest power of 2 that can be precisely represented by IEEE floating point.
                else
                    histogram.binsize * 2
            newhistogram = makehistogram newbinsize
            for newbin, newcount of histogram when newbin not in ['binsize', 'length']
                newhistogram = pushhistogram newhistogram, newbin, newcount
            newhistogram
        else
            histogram
    else
        histogram[bin] += count
        histogram

module.exports =
    aggregate: (lines) ->
        total = 0
        count = 0
        min = Math.min()
        max = Math.max()
        histogram = makehistogram()
        for line in lines
            total += line.value * line.count
            count += line.count
            min = Math.min line.value, min
            max = Math.max line.value, max
            histogram = pushhistogram histogram, line.value, line.count

        delete histogram.length

        starttime: lines.starttime
        endtime: lines.endtime
        count: count
        mean: total / count
        min: min
        max: max
        histogram: histogram
    combine: (chunks, starttime, endtime) ->
        filtered = (chunk for chunk in chunks when chunk.starttime < endtime and chunk.endtime > starttime)
        if filtered.length == 0
            ret =
                starttime: starttime
                endtime: endtime
                count: 0
                histogram: makehistogram()
            return ret

        weight = (s, e) -> ((if e < endtime then e else endtime) - (if s > starttime then s else starttime)) / (e - s)

        min = null
        max = null
        total = 0
        count = 0
        histogram = makehistogram Math.max (chunk.histogram.binsize for chunk in filtered)...
        for chunk in filtered
            if not min?
                min = chunk.min
                max = chunk.max
            else
                min = Math.min min, chunk.min
                max = Math.max max, chunk.max

            w = weight chunk.starttime, chunk.endtime
            count += chunk.count * w
            total += chunk.mean * chunk.count * w

            for k, v of chunk.histogram when k not in ['binsize', 'length']
                histogram = pushhistogram histogram, k, v * w

        delete histogram.length

        starttime: starttime
        endtime: endtime
        count: count
        mean: total / count
        min: min
        max: max
        histogram: histogram