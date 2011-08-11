#### Visu
#
# **Visu** shows linked data!

#### Installation
#
# Visu requires [Node.js](http://nodejs.org/) (`brew install node`)
# and [npm](http://npmjs.org) (`curl http://npmjs.org/install.sh | sh`) for
# installation. To install the dependencies once npm is available:
#
#     npm install
#     npm install supervisor -g
#     supervisor


#### Usage
#
# Browse [http://localhost/locations](http://localhost:7155/) to witness the magic

express = require 'express'
app = express.createServer()
app.set 'view engine', 'jade'
jade = require 'jade'

#### Routing
#
# To see the visualization, GET `/`
# To see a vs between two streams `/:datastream1,:datastream2`

app.get '/', (req, res) ->
  versus '', '', req, res

app.get '/:datasream1,:datastream2', (req, res) ->
  versus req.params.datastream1, req.params.datastream2, req, res

versus = (datastream1, datastream2, req, res) ->
  res.writeHead 200, "Content-Type": "text/html"
  setInterval ( -> res.write '\n'), 30000

  res.render 'versus', locals: datastream1: datastream1, datastream2: datastream2

app.use express.static(__dirname + '/public')
app.use app.router
app.listen 7155
