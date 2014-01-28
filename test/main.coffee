
should = require('should')
http = require('http')
request = require('request')
fs = require('fs')
votingtest = require('./voting')
votetests = require('./vote')

port = process.env.PORT || 3333

describe "app", ->

  if process.env.MOCHA_DEBUG_RUN
    console.log("Running for sending requests to localhost:#{port}")
  else
    app = require(__dirname + '/../lib/app')
    server = []

    before (done) ->
      app.sync (err) ->
        return done(err) if err

        server = http.createServer(app)
        server.listen port, (err, result) ->
          return done(err) if err
          done()

    after (done) ->
      server.close()
      done()

    it "should exist", (done) ->
      should.exist app
      done()

  it "should be listening at localhost:#{port}", (done) ->
    request "http://localhost:#{port}/", (err, res) ->
      return done err if err
      res.statusCode.should.eql 200
      done()

  votingtest(port)
  votetests(port)