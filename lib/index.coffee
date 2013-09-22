datePattern = /^([-+]?\d+)(second|minute|hour|day|month|year)s?$/

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

module.exports =
    aggregators: require './aggregators'
    dateParse: dateParse
    serializer: require './serializer'
