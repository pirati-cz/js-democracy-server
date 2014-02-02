appinit = require('./lib/app')
port = process.env.PORT || 8080

appinit (err, app) ->
  if err
    console.log err
  else
    app.listen port, ->
      console.log('listening ...')
