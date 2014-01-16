
should = require('should')
request = require('request')
moment = require('moment')


module.exports = (port) ->

  s = "http://localhost:#{port}"

  it "must not create a vote if requred param is missing", (done) ->
    votingwithoutname =
      desc: 'testin voting'

    request.post "#{s}/voting/", {form: votingwithoutname}, (err, res) ->
      return done err if err
      res.statusCode.should.eql 400
      done()


  it "shall return empty voting list", (done) ->
    request "#{s}/votinglist/", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      JSON.parse(body).should.eql []
      done()


  it "should create new voting on right POST request", (done) ->
    voting =
      id: 1,
      name: 'voting1',
      desc: 'testin voting'
      begin: moment().add('days', 2).format(),
      category_id: 2

    request.post "#{s}/voting/", {form: voting}, (err, res) ->
      return done err if err
      res.statusCode.should.eql 201
      res.should.be.json
      done()


  it "shall return voting list of lenght 1 (just created)", (done) ->
    request "#{s}/votinglist/", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      JSON.parse(body).length.should.eql 1
      done()


  it "shall return voting with given ID", (done) ->
    request "#{s}/voting/1/", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      voting = JSON.parse(body)
      voting.name.should.eql 'voting1'
      voting.desc.should.eql 'testin voting'
      done()


  it "shall update voting with given ID with desired values", (done) ->
    changed = {name: "The changed voting"}

    request.put "#{s}/voting/1/", {form: changed}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      voting = JSON.parse(body)
      voting.name.should.eql 'The changed voting'
      voting.desc.should.eql 'testin voting'
      done()

