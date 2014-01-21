
moment = require('moment')
errors = require('../errors')
models = require('../models')
utils = require('./utils')

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

checkOptions = (options) ->
  if !options or options is []
    return 'no options provided'


###
POST /voting/
Creates a new voting according request data (admin only).
###
exports.createVoting = (req, res, next) ->

  err = checkVotingInterva(req.body)
  return next(err) if err

  err = checkOptions(req.body.options)
  return next(err) if err

  models.Voting.create(req.body).complete (savedvoting, err) ->
    return next(err) if err

    utils.saveOptions savedvoting, req.body.options, (opts, err) ->
      return next(err) if err

      req.log.debug({voting: savedvoting}, "createVoting: done")
      res.send(201, savedvoting)


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
  utils.retrieveVoting({id: req.params.votingID}
  , (found) ->
    utils.retrieveOptions(found, (opts) ->
      rv = Object(found.dataValues)
      rv.options = opts
      res.send 200, rv
    )
  , (err) ->
    next(err)
  )

###
PUT /voting/:votingID/
Updates a new voting according request data (admin only).
###
exports.updateVoting = (req, res, next) ->
  models.Voting.find(
    where: {id: req.params.votingID},
  ).complete (voting, err) ->
    return next(err) if err

    err = checkOptions(req.body.options)
    return next(err) if err

    found.updateAttributes(req.body).complete (updated, err) ->
      return next(err) if err

      updated.setOptions([]).complete (opts, err) ->
        return next(err) if err

        utils.saveOptions updated, req.body.options, (opts, err) ->
          return next(err) if err

          rv = Object(updated.dataValues)
          rv.options = opts
          res.send 200, rv

