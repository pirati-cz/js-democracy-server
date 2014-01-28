
should = require('should')
request = require('request')
moment = require('moment')


module.exports = (port) ->

  getVotingObj = ->
    v =
      name: "test voting 1"
      desc: "testing voting 1 desc"
      category_id: 2
      begin: moment().add('days', 2).format()
      options: [
        { name: 'to1', desc: 'testin option 1', url: 'http://pirati.cz' }
      ]

  s = "http://localhost:#{port}"


  it "must not create a vote if requred param (name) is missing", (done) ->
    votingwithoutname = getVotingObj()
    delete votingwithoutname['name']

    request.post "#{s}/voting", {form: votingwithoutname}, (err, res) ->
      return done err if err
      res.statusCode.should.eql 400
      done()


  it "must fail with 400 if no option is provided", (done) ->
    votingwithoutopts = getVotingObj()
    delete votingwithoutopts['options']

    request.post "#{s}/voting", {form: votingwithoutopts}, (err, res) ->
      return done err if err
      res.statusCode.should.eql 400
      done()


  it "shall return empty voting list", (done) ->
    request "#{s}/voting", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      JSON.parse(body).should.eql []
      done()


  it "shall return 404 on get nonexistent voting", (done) ->
    request "#{s}/voting/22222/", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 404
      done()


  it "should create new voting on right POST request", (done) ->
    request.post "#{s}/voting/", {form: getVotingObj()}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 201
      res.should.be.json
      voting = JSON.parse(body)
      voting.desc.should.eql 'testing voting 1 desc'
      voting.options.length.should.eql 1
      done()


  it "shall return voting list of lenght 1 (just created)", (done) ->
    request "#{s}/voting", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      JSON.parse(body).length.should.eql 1
      done()


  it "shall return voting with given ID", (done) ->
    request "#{s}/voting/1/", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      voting = JSON.parse(body)
      voting.name.should.eql getVotingObj().name
      voting.desc.should.eql getVotingObj().desc
      voting.options.length.should.eql 1
      voting.options[0].name = 'to1'
      done()

  changed =
    name: "The changed voting",
    options: [
      { name: 'to1', desc: 'testin option 1', url: 'http://pirati.cz' }
      { name: 'to2', desc: 'testin option 2', url: 'http://pirati.cz/mo' }
    ]

  it "shall update voting with given ID with desired values", (done) ->
    request.put "#{s}/voting/1/", {form: changed}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      voting = JSON.parse(body)
      voting.name.should.eql 'The changed voting'
      voting.desc.should.eql 'testing voting 1 desc'
      voting.options.length.should.eql 2
      done()

  it "must not update voting with empty options", (done) ->
    changed = { options: [] }

    request.put "#{s}/voting/1/", {form: changed}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 400
      done()
      
  it "shall return 404 on updating nonexistent voting", (done) ->
    request.put "#{s}/voting/22222/", {form: changed}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 404
      done()

