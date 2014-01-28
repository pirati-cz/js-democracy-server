if(process.env.NODE_ENV && process.env.NODE_ENV == 'production') {
  require('coffee-script');
  var app = require('./lib/app');
} else {
  process.env.PORT = 3000;
  process.env.NODE_ENV = 'devel';
  process.env.POSTGRESQL_URL = 'postgres://bebyksvndezspz:W4JowMVE1SyKl-WaykAw0oZjsM@ec2-23-21-243-117.compute-1.amazonaws.com:5432/ddc648q43795dt';
  var app = require('./target/app');
}

var port = process.env.PORT || 8080;

console.log('starting in %s, at %s, port: %s',
  __dirname, process.env.NODE_ENV, port);

app.sync(function(err){
  if(err) {
    console.log(err);
  } else {
    app.listen(port, function() {
      console.log('listening ...');
    });
  }
});
