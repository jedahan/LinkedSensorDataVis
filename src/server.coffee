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
request = require 'request'
app = express.createServer()
app.set 'view engine', 'jade'
jade = require 'jade'
database = "http://localhost/api"
environment = null
datastream0 = null
datastream1 = null

#### Routing
#
# To see the visualization, GET `/`
# To see a vs between two streams `/:datastream1,:datastream2`

app.get '/', (req, res) ->
  console.log 'GET /'
  versus '', '', req, res

app.get '/:datastream0,:datastream1', (req, res) ->
  console.log "GET /#{datastream0},#{datastream1}"
  versus req.params.datastream1, req.params.datastream2, req, res

versus = (datastream0, datastream1, req, res) ->
  console.log "versus(#{datastream0},#{datastream1}, req, res)"
  setInterval ( -> res.write '\n'), 30000

  request.get "#{database}/environment", (error, res, body) ->
    if error?
      console.log "e: #{error}"
    else
      environment = JSON.parse body
      datastream0 ?= environment.datastreams[0].id
      datastream1 ?= environment.datastreams[1].id

      renderStreams datastream0, datastream1

renderStreams = (datastream0, datastream1) ->
  console.log "renderStreams(#{datastream0},#{datastream1})"
  request.get "#{database}/datastreams/#{datastream0}", (error, res, body) ->
    if not error?
      stream0 = JSON.parse body
      graph()
  request.get "#{database}/datastreams/#{datastream1}", (error, res, body) ->
    if not error?
      stream1 = JSON.parse body
      graph()

graph = ->
  console.log 'graph()'
  if stream0? and stream1?
    console.log "stream0: #{stream0}"
    console.log "stream1: #{stream1}"
    res.render 'versus', locals: datastream0: stream0, datastream1: stream1

    setInterval(
      request.get "#{database}/datastreams/datastream0/datapoints", (error, res, body) ->
        updateData "datastream0", JSON.parse body
      request.get "#{database}/datastreams/datastream1/datapoints", (error, res, body) ->
        updateData "datastream1", JSON.parse body
    , 5000)

updateResource = (streamnamegraph, datapoint) ->
  console.log "updateResource(#{streamnamegraph}, #{datapoint})"
  console.log "updating #{streamname} with #{JSON.stringify datapoint}"


app.use express.static(__dirname + '/public')
app.use app.router
app.listen 7155
