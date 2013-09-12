
should = require('should')
http = require('http')
request = require('request')
fs = require('fs')
votingtest = require('./voting')
votetests = require('./vote')

process.env.SQLITE_URL = __dirname + '/../testdb.sqlite'

app = require(__dirname + '/../lib/app')
port = 8080
server = http.createServer(app)


db = require(__dirname + '/../lib/models')


describe "app", ->

  before (done) ->
    db.sequelize.sync()
    server.listen port, (err, result) ->
      return done err if err
      done()

  after (done) ->
    server.close()
    fs.unlink process.env.SQLITE_URL, (err) ->
      return done(err) if err
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