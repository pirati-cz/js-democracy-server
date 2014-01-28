assert = require("assert-plus")
bunyan = require("bunyan")
express = require("express")
cors = require('cors')
api = require('./api')
models = require('./models')

createLogger = () ->

  # In true UNIX fashion, debug messages go to stderr, and audit records go
  # to stdout, so you can split them as you like in the shell
  default_stream =
    level: (process.env.LOG_LEVEL || 'info'),
    stream: process.stderr

  debug_stream =
    # This ensures that if we get a WARN or above all debug records
    # related to that request are spewed to stderr - makes it nice
    # filter out debug messages in prod, but still dump on user
    # errors so you can debug problems
    level: 'debug',
    stream: process.stderr

  bunyan.createLogger
    name: "democracy-server",
    streams: [default_stream, debug_stream]


errorHandler = (err, req, res, next) ->
  return next(err) if typeof(err) != 'number'
  res.send err


app = express()
logger = createLogger()

app.configure ->
  app.use express.logger("dev") # 'default', 'short', 'tiny', 'dev'
  app.use(express.compress())
  app.use(express.methodOverride())
  app.use(express.json())
  app.use(express.urlencoded())
  app.use((req, res, next) ->
    req.log = logger
    next()
  )
  app.use(cors({maxAge: 86400}))
  app.use(app.router)
  app.use(errorHandler)

  api.createAPI(app)

  # Register a default '/' handler
  app.get "/", (req, res, next) ->
    res.send 200, app.routes

app.sync = (done) ->
  models.sequelize.sync().success ->
    done()
  .error (e) ->
    done(e)

module.exports = app
