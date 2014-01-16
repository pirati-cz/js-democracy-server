
moment = require('moment')
errors = require('../errors')
models = require('../models')

DAY = (1000 * 60 * 60 * 24)
DEFAULT_DURATION = process.env.VOTINGDEFAULTDURATION or DAY


checkVotingInterva = (voting) ->
  now = new Date()

  voting.begin = new Date(voting.begin) if voting.begin not instanceof Date
  if not voting.end
    voting.end = moment(voting.begin).add('days', DEFAULT_DURATION).toDate()
  else
    voting.end = new Date(voting.end) if voting.end not instanceof Date

  diff = voting.end.getTime() - voting.begin.getTime()
  return 'end before begin' if diff < 0
  if diff < (process.env.VOTINGMININTERVAL or DAY)
    return 'too small interval'

  fromNow = voting.begin.getTime() - now.getTime()
  if fromNow < (process.env.VOTINGMINDELAY or DAY)
    return 'too early voting begin'


###
POST /voting/
Creates a new voting according request data (admin only).
###
exports.createVoting = (req, res, next) ->
  v = models.Voting.build(req.body)

  err = checkVotingInterva(v)
  return res.send(400, err) if err

  v.save().success((savedvoting) ->
    req.log.debug
      voting: savedvoting
      , "createVoting: done"
    res.send(201, v)
  ).error (err) ->
    res.send(400, err)

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
