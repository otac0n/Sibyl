dgram = require 'dgram'
fs = require 'fs'
PEG = require 'pegjs'
lib = require './lib'
aggregators =
    is: require './aggregators/is'
    took: require './aggregators/took'
    hit: require './aggregators/hit'
    happened: require './aggregators/happened'

parser = PEG.buildParser fs.readFileSync('protocol.pegjs', 'utf8')
server = dgram.createSocket 'udp4'

buckets = starttime: Date.now()

server.on "message", (msg, rinfo) ->
    time = Date.now()
    msg = msg.toString 'utf8'
    lines = parser.parse msg
    for line in lines
        if not line
            # skip badlines for now
        else
            line.time = time
            (buckets[line.type + '-' + line.name] ?= []).push line

update = ->
    chunk = buckets
    chunk.endtime = Date.now()
    buckets = starttime: chunk.endtime
    for key, lines of chunk when lines.length
        lines.starttime = chunk.starttime
        lines.endtime = chunk.endtime
        aggregate = aggregators[lines[0].type].aggregate lines, key, buckets
        lib.serializer.append key, aggregate, (err) ->
            if err then console.log key, err

setInterval update, 10000
server.bind process.env.PORT
