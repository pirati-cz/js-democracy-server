

errors = require('../errors')
models = require('../models')


###
POST /vote/:votingID/
Actually votes for given option og given voting.
If there is already voted, the record will be updated.
###
exports.doVote = (req, res, next) ->
  models.Voting.find({where: {id: req.params.votingID}}).success((voting) ->
    res.send 404, "Voting not found" if not voting
      
    models.Vote.find(
      where:
        user_id: 1, # TODO: get user_id from req
        votingId: req.params.votingID
    ).success((vote) ->
      if not vote
        vote =  models.Vote.build
          user_id: 1,
          votingId: req.params.votingID
      vote.preference = req.body.preference
      vote.note = req.body.note
      vote.save().success((saved) ->
        req.log.debug
          voting: saved
        res.send 201, saved
      ).error (err) ->
        next(err)    
    ).error (err) ->
      next(err)
  ).error (err) ->
    next(err)
