
var app = require('./target/app');

var port = process.env.PORT || 8080;

console.log('starting at port: %s', port);

app.listen(port, function() {
  console.log('listening ...');
});
