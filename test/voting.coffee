
should = require('should')
request = require('request')

module.exports = (port) ->
  
  s = "http://localhost:#{port}"

  it "must not create a vote if requred param is missing", (done) ->
    votingwithoutname =
      desc: 'testin voting'

    request.post "#{s}/voting/", {form: votingwithoutname}, (err, res) ->
        return done err if err
        res.statusCode.should.eql 404
        done()


  it "shall return empty voting list", (done) ->
    request "#{s}/votinglist/", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      body.should.eql []
      done()


  it "should create new voting on right POST request", (done) ->
    voting =
      name: 'voting1',
      desc: 'testin voting'

    request.post "#{s}/voting/", {form: voting}, (err, res) ->
        return done err if err
        res.statusCode.should.eql 201
        res.body.should.not.be null
        done()


  it "shall return voting list of lenght 1 (just created)", (done) ->
    request "#{s}/votinglist/", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      body.lenght.should.eql 1
      done()

  
  it "shall return voting with given ID", (done) ->
    request "#{s}/voting/1/", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      body.lenght.should.eql 1
      done()


  it "shall update voting with given ID with desired values", (done) ->
    changed = {name: "The changed voting"}
      
    request.put "#{s}/voting/1/", {form: changed}, (err, res) ->
      return done err if err
      res.statusCode.should.eql 201
      res.body.should.not.be null
      done()

