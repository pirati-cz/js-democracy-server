if(process.env.DEVMACHINE) {
  process.env.PORT = 8080;
  var app = require('./tmp/app');
} else {
  require('coffee-script');
  var app = require('./lib/app');
}

app.listen((process.env.PORT || 8080), function onListening() {
  console.log('listening at %s', process.env.PORT);
});
