should = require('should')
request = require('request')


module.exports = (port) ->
  
  s = "http://localhost:#{port}"
  optWithouName =
    id: 1,
    desc: 'testin voting'

  it "must not create an option if requred param is missing", (done) ->
    request.post "#{s}/options/1/", {form: optWithouName}, (err, res) ->
      return done err if err
      res.statusCode.should.eql 400
      done()        
        
  it "must not create an option for notexisting voting", (done) ->
    request.post "#{s}/options/1111/", {form: optWithouName}, (err, res) ->
      return done err if err
      res.statusCode.should.eql 404
      done()
  
  it "creates an option for 1 voting with desired params", (done) ->
    opt =
      id: 1,
      name: 'testin option'
      desc: 'testin option desc'
      url: 'http://pirati.cz'
      
    request.post "#{s}/options/1/", {form: opt}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 201
      o = JSON.parse(body)
      o.name.should.eql opt.name
      o.desc.should.eql opt.desc
      done()        
        
  it "updates an option for 1 voting with desired params", (done) ->
    changed = {desc: "The changed option"}    
    request.put "#{s}/options/1/1/", {form: changed}, (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 200
      o = JSON.parse(body)
      o.name.should.eql 'testin option'
      o.desc.should.eql changed.desc
      done()
      
  
  it "deletes an option from 1 voting with desired params", (done) ->
    request.del "#{s}/options/1/1/", (err, res) ->
      return done err if err
      res.statusCode.should.eql 204
      done()
      