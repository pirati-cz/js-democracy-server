
should = require('should')
http = require('http')
request = require('request').defaults({timeout: 5000})
fs = require('fs')
votingtest = require('./voting')
votetests = require('./vote')

port = process.env.PORT || 3333

mongoose = require('mongoose')
mockgoose = require('mockgoose')
mockgoose(mongoose)


describe "app", ->

  if process.env.MOCHA_DEBUG_RUN
    console.log("Running for sending requests to localhost:#{port}")
  else
    app = []
    server = []

    before (done) ->
      require(__dirname + '/../lib/app') (err, createdapp) ->
        return done(err) if err

        app = createdapp
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