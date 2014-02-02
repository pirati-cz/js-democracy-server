
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
      opts: [
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
    delete votingwithoutopts['opts']

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
    request "#{s}/voting/22222", (err, res, body) ->
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
      voting.opts.length.should.eql 1
      done()

  created = undefined
  createdURI = undefined

  it "shall return voting list of lenght 1 (just created)", (done) ->
    request "#{s}/voting", (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      votings = JSON.parse(body)
      votings.length.should.eql 1
      created = votings[0]
      created.name.should.eql getVotingObj().name
      created.opts[0].name.should.eql getVotingObj().opts[0].name

      createdURI = "#{s}/voting/#{created._id}/"
      done()

  it "shall return voting with given ID", (done) ->
    request createdURI, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      voting = JSON.parse(body)
      voting.name.should.eql getVotingObj().name
      voting.desc.should.eql getVotingObj().desc
      voting.opts.length.should.eql 1
      voting.opts[0].name = 'to1'
      done()

  changed =
    name: "The changed voting",
    opts: [
      { name: 'to1', desc: 'testin option 1', url: 'http://pirati.cz' }
      { name: 'to2', desc: 'testin option 2', url: 'http://pirati.cz/mo' }
    ]

  it "shall update voting with given ID with desired values", (done) ->
    request.put createdURI, {form: changed}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      voting = JSON.parse(body)
      voting.name.should.eql 'The changed voting'
      voting.desc.should.eql 'testing voting 1 desc'
      voting.opts.length.should.eql 2
      done()

  it "must not update voting with empty options", (done) ->
    changed = { options: [] }

    request.put createdURI, {form: changed}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 400
      done()

  it "shall return 404 on updating nonexistent voting", (done) ->
    request.put "#{s}/voting/22222/", {form: changed}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 404
      done()

