
var app = require('./dist/app');

app.listen((process.env.PORT || 8080), function () {
  console.log('listening at %s', process.env.PORT);
});
