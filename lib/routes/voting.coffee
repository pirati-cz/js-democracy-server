

errors = require('../errors')
models = require('../models')


###
POST /voting/
Creates a new voting according request data (admin only).
###
exports.createVoting = (req, res, next) ->
  v = models.Voting.build(req.body)
  v.save().success((savedvoting) ->
    req.log.debug
      voting: savedvoting
      , "createVoting: done"
    res.send(201, v)
  ).error (err) ->
    next(err)
    
###
GET /votinglist/
Lists all votings which authenticated (or delegated) user can vote.
Currently all.
###
exports.getVotinglist = (req, res, next) ->
  models.Voting.findAll().success (found) ->
    res.send 200, found

###
GET /voting/:votingID/
Retrieves all informations abount given voting.
###
exports.getVoting = (req, res, next) ->
  models.Voting.find(
    where: {id: req.params.votingID},
  ).success((found) ->
    res.send 200, found
  ).error (err) ->
    next(err)
  

###
PUT /voting/:votingID/
Updates a new voting according request data (admin only).
###
exports.updateVoting = (req, res, next) ->
  models.Voting.find(
    where: {id: req.params.votingID},
  ).success((found) ->
    found.updateAttributes(req.body).success((updated) ->
      res.send 200, updated
    ).error (err) ->
      next(err)
  ).error (err) ->
    next(err)
  