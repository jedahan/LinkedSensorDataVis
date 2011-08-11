(function() {
  var app, express, jade, versus;
  express = require('express');
  app = express.createServer();
  app.set('view engine', 'jade');
  jade = require('jade');
  app.get('/', function(req, res) {
    return versus('', '', req, res);
  });
  app.get('/:datasream1,:datastream2', function(req, res) {
    return versus(req.params.datastream1, req.params.datastream2, req, res);
  });
  versus = function(datastream1, datastream2, req, res) {
    res.writeHead(200, {
      "Content-Type": "text/html"
    });
    setInterval((function() {
      return res.write('\n');
    }), 30000);
    return res.render('versus', {
      locals: {
        datastream1: datastream1,
        datastream2: datastream2
      }
    });
  };
  app.use(express.static(__dirname + '/public'));
  app.use(app.router);
  app.listen(7155);
}).call(this);
