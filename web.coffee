express = require 'express'
ejs = require 'ejs'

app = express()
app.engine('ejs', ejs.renderFile);
app.set('view engine', 'ejs');
app.set('views', __dirname + '/controllers')

(require './controllers/home').init app
(require './controllers/graph').init app

console.log 'listening on', process.env.PORT
app.listen process.env.PORT
