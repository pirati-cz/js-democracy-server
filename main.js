if(process.env.NODE_ENV && process.env.NODE_ENV == 'production') {
  require('coffee-script');
  var app = require('./lib/app');
} else {
  process.env.PORT = 3000;
  var app = require('./target/app');
}

var port = process.env.PORT || 8080;

console.log('starting at port: %s', port);

app.listen(port, function() {
  console.log('listening ...');
});
