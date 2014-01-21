
moment = require('moment')
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
    return 400 # 'too small interval'

  fromNow = voting.begin.getTime() - now.getTime()
  if fromNow < (process.env.VOTINGMINDELAY or DAY)
    return 400 # 'too early voting begin'

checkOptions = (options) ->
  if !options or options is []
    return 400 # 'no options provided'


###
POST /voting/
Creates a new voting according request data (admin only).
###
exports.createVoting = (req, res, next) ->

  err = checkVotingInterva(req.body)
  return next(err) if err

  err = checkOptions(req.body.options)
  return next(err) if err

  models.Voting.create(req.body).complete (err, voting) ->
    return next(400) if err

    utils.saveOptions voting, req.body.options, (err) ->
      return next(400) if err

      req.log.debug({voting: voting}, "createVoting: done")
      rv = Object(voting.dataValues)
      rv.options = req.body.options
      res.send(201, rv)


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
  utils.retrieveVoting {id: req.params.votingID}, (e, voting) ->
    return next(e) if e
    return next(404) if not voting

    utils.retrieveOptions voting, (e, opts) ->
      return next(e) if e

      rv = Object(voting.dataValues)
      rv.options = opts
      res.send 200, rv


###
PUT /voting/:votingID/
Updates a new voting according request data (admin only).
###
exports.updateVoting = (req, res, next) ->
  utils.retrieveVoting {id: req.params.votingID}, (e, voting) ->
    return next(e) if e
    return next(404) if not voting

    err = checkOptions(req.body.options)
    return next(err) if err

    voting.updateAttributes(req.body).complete (err, updated) ->
      return next(err) if err

      updated.setOptions([]).complete (err, delOpts) ->
        return next(err) if err

        utils.saveOptions updated, req.body.options, (err) ->
          return next(err) if err

          rv = Object(updated.dataValues)
          rv.options = req.body.options
          res.send 200, rv

