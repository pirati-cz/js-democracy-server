

errors = require('../errors')
models = require('../models')


###
PUSH /vote/:votingID/:optionID/
Actually votes for given option og given voting.
If there is already voted, the record will be updated.
###
exports.doVote = (req, res, next) ->
  res.send 200, "vote: #{req.params.votingID}, #{req.params.optionID}"
  next()
