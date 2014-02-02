
moment = require('moment')

DAY = (1000 * 60 * 60 * 24)
DEFAULT_DURATION = process.env.VOTINGDEFAULTDURATION or DAY

module.exports = (models) ->

  checkVotingInterval = (voting) ->
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

  checkOptions = (body) ->
    if !body.opts or body.opts is []
      return 400 # 'no options provided'


  ###
  Finds voting and stores it in req. React appropriately on errors.
  ###
  findVoting = (req, res, next) ->
    q = models.Voting.findById(req.params.votingID)
    q.exec (err, voting) ->
      return next(404) if err || not voting

      req.voting = voting
      next()

  ###
  POST /voting/
  Creates a new voting according request data (admin only).
  ###
  createVoting = (req, res, next) ->

    err = checkVotingInterval(req.body)
    return next(err) if err

    err = checkOptions(req.body)
    return next(err) if err

    voting = new models.Voting(req.body)
    voting.save (err) ->
      return next(400) if err

      req.log.debug({voting: voting}, "createVoting: done")
      res.send(201, voting)


  ###
  GET /votinglist/
  Lists all votings which authenticated (or delegated) user can vote.
  Currently all.
  ###
  getVotinglist = (req, res, next) ->
    q = models.Voting.find()
    q.exec  (err, found) ->
      return next(err) if err

      res.send 200, found


  ###
  GET /voting/:votingID/
  Retrieves all informations abount given voting.
  ###
  getVoting = (req, res, next) ->
    res.send 200, req.voting


  ###
  PUT /voting/:votingID/
  Updates a new voting according request data (admin only).
  ###
  updateVoting = (req, res, next) ->
    err = checkOptions(req.body)
    return next(err) if err

    for k, v of req.body
      req.voting[k] = v

    req.voting.save (err) ->
      return next(err) if err

      res.send 200, req.voting


  # return
  createVoting: createVoting
  getVotinglist: getVotinglist
  getVoting: getVoting
  updateVoting: updateVoting
  findVoting: findVoting