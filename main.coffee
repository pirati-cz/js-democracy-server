app = require('./lib/app')
port = process.env.PORT || 8080

app.sync (err) ->
  if err
    console.log err
  else
    app.listen port, ->
      console.log('listening ...')
