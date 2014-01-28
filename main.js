if(process.env.NODE_ENV && process.env.NODE_ENV == 'production') {
  require('coffee-script');
  var app = require(__dirname +'/lib/app');
} else {
  process.env.PORT = 3000;
  process.env.NODE_ENV = 'devel';
  var app = require(__dirname + '/target/app');
}

var port = process.env.PORT || 8080;

console.log('starting in %s, at %s, port: %s',
  __dirname, process.env.NODE_ENV, port);

app.listen(port, function() {
  console.log('listening ...');
});
