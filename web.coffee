express = require 'express'
app = express()

(require './controllers/index').init app
(require './controllers/graph').init app

console.log 'listening on', process.env.PORT
app.listen process.env.PORT
