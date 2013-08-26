
var voteserver = require('./tmp/server');

var options = {
  app_name: 'pokus',
//  user: 'vencax',
//  password: 'heslo'
};

var server = voteserver.createServer(options);

process.env.PORT = 8080;
server.listen((process.env.PORT || 8080), function onListening() {
  console.log('listening at %s', server.url);
});
