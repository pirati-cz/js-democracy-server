
should = require('should')
request = require('request')

module.exports = (port) ->

  it "should return 404 on vote in notexisting voting", (done) ->
    request.post "http://localhost:#{port}/vote/1111", (err, res) ->
      return done err if err
      res.statusCode.should.eql 404
      done()

  it "should return 201 and voteinfo on successful vote", (done) ->
    request "http://localhost:#{port}/voting", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      created = JSON.parse(body)[0]
      uri = "http://localhost:#{port}/vote/#{created._id}"

      console.log("ted: #{uri}")
      request.post uri, (err, res) ->
        return done err if err
        res.statusCode.should.eql 201
        res.should.be.json
        done()