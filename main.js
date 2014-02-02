
process.env.PORT = 3000;
process.env.NODE_ENV = 'devel';
var mongoose = require('mongoose');
var mockgoose = require('mockgoose');
mockgoose(mongoose);

var port = process.env.PORT || 8080;

console.log('starting in %s, at %s, port: %s',
  __dirname, process.env.NODE_ENV, port);

var appinit = require('./target/app');
appinit(function(err, app) {
  if(err) {
    console.log(err);
  } else {
    app.listen(port, function() {
      console.log('listening ...');
    });
  }
});
