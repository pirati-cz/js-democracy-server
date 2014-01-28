app = require('./lib/app')
port = process.env.PORT || 8080

app.listen port, ->
  console.log('listening ...')
