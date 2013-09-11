
var voteserver = require('./tmp/server');

var app = voteserver.app;

process.env.PORT = 8080;
app.listen((process.env.PORT || 8080), function onListening() {
  console.log('listening at %s', process.env.PORT);
});
