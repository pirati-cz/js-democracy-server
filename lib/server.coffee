assert = require("assert-plus")
bunyan = require("bunyan")
restify = require("restify")
api = require('./api')

#/--- Formatters

###
This is a nonsensical custom content-type 'application/todo', just to
demonstrate how to support additional content-types.  Really this is
the same as text/plain, where we pick out 'task' if available
###
formatTodo = (req, res, body) ->
  if body instanceof Error
    res.statusCode = body.statusCode or 500
    body = body.message
  else if typeof (body) is "object"
    body = body.task or JSON.stringify(body)
  else
    body = body.toString()
  res.setHeader "Content-Length", Buffer.byteLength(body)
  body

#/--- Handlers

###
Only checks for HTTP Basic Authenticaion

Some handler before is expected to set the accepted user/pass combo
on req as:

req.allow = { user: '', pass: '' };

Or this will be skipped.
###
authenticate = (req, res, next) ->
  unless req.allow
    req.log.debug "skipping authentication"
    next()
    return
  authz = req.authorization.basic
  unless authz
    res.setHeader "WWW-Authenticate", "Basic realm=\"todoapp\""
    next new restify.UnauthorizedError("authentication required")
    return
  if authz.username isnt req.allow.user or authz.password isnt req.allow.pass
    next new restify.ForbiddenError("invalid credentials")
    return
  next()
  
createLogger = (options) ->

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
    type: 'raw',
    stream: new restify.bunyan.RequestCaptureStream({
      level: bunyan.WARN,
      maxRecords: 100,
      maxRequestIds: 1000,
      stream: process.stderr
    })
            
  bunyan.createLogger
    name: options.app_name,
    streams: [default_stream, debug_stream],
    serializers: restify.bunyan.serializers


###
Returns a server with all routes defined on it
###
createServer = (options) ->
  assert.object options, "options"
  
  # Create a server with our logger and custom formatter
  # Note that 'version' means all routes will default to
  # 1.0.0
  server = restify.createServer(
    formatters:
      "application/todo; q=0.9": formatTodo

    log: createLogger(options)
    name: options.app_name
    version: "1.0.0"
  )
  
  # Ensure we don't drop data on uploads
  server.pre restify.pre.pause()
  
  # Clean up sloppy paths like //todo//////1//
  server.pre restify.pre.sanitizePath()
  
  # Handles annoying user agents (curl)
  server.pre restify.pre.userAgentConnection()
  
  # Set a per request bunyan logger (with requestid filled in)
  server.use restify.requestLogger()
  
  # Allow 5 requests/second by IP, and burst to 10
  server.use restify.throttle(
    burst: 10
    rate: 5
    ip: true
  )
  
  # Use the common stuff you probably want
  server.use restify.acceptParser(server.acceptable)
  server.use restify.dateParser()
  server.use restify.authorizationParser()
  server.use restify.queryParser()
  server.use restify.gzipResponse()
  server.use restify.bodyParser()
  
  # Now our own handlers for authentication/authorization
  # Here we only use basic auth, but really you should look
  # at https://github.com/joyent/node-http-signature
  server.use setup = (req, res, next) ->
    req.dir = options.directory
    if options.user and options.password
      req.allow =
        user: options.user
        password: options.password
    next()

  server.use authenticate
  
  api.createRoutes(server)
  
  # Register a default '/' handler
  server.get "/", root = (req, res, next) ->
    routes = [
      "GET     /",
      "POST    /todo",
      "GET     /todo",
      "DELETE  /todo",
      "PUT     /todo/:name",
      "GET     /todo/:name",
      "DELETE  /todo/:name"
    ]
    res.send 200, routes
    next()
  
  # Setup an audit logger
  server.on "after", restify.auditLogger(
    body: true
    log: bunyan.createLogger(
      level: "info"
      name: "todoapp-audit"
      stream: process.stdout
    )
  )
  server

module.exports = createServer: createServer