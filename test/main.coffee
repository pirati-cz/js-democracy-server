
should = require('should')
http = require('http')
request = require('request')

app = require(__dirname + '/../lib/app')
port = 8080
server = http.createServer(app)


describe "app", ->
  
  before (done) ->
    server.listen port, (err, result) ->
      return done err if err
      done()

  after (done) ->
    server.close ->
      done()

  it "should exist", (done) ->
    should.exist app
    done()

  it "should be listening at localhost:#{port}", (done) ->
    request "http://localhost:#{port}/", (err, res) ->
      return done err if err
      res.statusCode.should.eql 200
      done()