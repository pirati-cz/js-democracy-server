
should = require('should')
request = require('request')

module.exports = (port) ->
  
  it "should return 404 on vote in notexisting voting", (done) ->
    request.post "http://localhost:#{port}/vote/1111/", (err, res) ->
      return done err if err
      res.statusCode.should.eql 404
      done()
  
  it "should return 201 and voteinfo on successful vote", (done) ->
    request.post "http://localhost:#{port}/vote/1/", (err, res) ->
      return done err if err
      res.statusCode.should.eql 201
      res.should.be.json
      done()