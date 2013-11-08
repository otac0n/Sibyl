fs = require 'fs'

module.exports =
    append: (key, chunk, callback) ->
        json = JSON.stringify chunk
        data = '\x0F' + json + '\x0E'
        fs.appendFile './data/' + key, data, callback
    read: (key, starttime, endtime, callback) ->
        fs.readFile "./data/" + key, { encoding: 'UTF8'}, (err, data) ->
            if err
                callback err
                return
            chunks = []
            chunkPattern = /\x0F([^\x0F\x0E]+)\x0E/g
            while (m = chunkPattern.exec data) != null
                chunk = JSON.parse m[1]
                if chunk.starttime <= endtime and chunk.endtime >= starttime
                    chunks.push chunk

            callback undefined, chunks
