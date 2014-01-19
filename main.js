
if(process.env.NODE_ENV && process.env.NODE_ENV == 'production') {
  require('coffee-script');
  var app = require('./lib/app');
} else {
  process.env.PORT = 3000;
  var app = require('./tmp/app');
}

app.listen((process.env.PORT || 8080), function () {
  console.log('listening at %s', process.env.PORT);
});
