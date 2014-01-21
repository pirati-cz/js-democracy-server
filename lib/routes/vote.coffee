

models = require('../models')


###
POST /vote/:votingID/
Actually votes for given option og given voting.
If there is already voted, the record will be updated.
###
exports.doVote = (req, res, next) ->
  models.Voting.find({where: {id: req.params.votingID}}).complete (e, voting) ->
    return next(e) if e
    return next(404) if not voting

    models.Vote.find(
      where:
        user_id: 1, # TODO: get user_id from req
        votingId: req.params.votingID
    ).complete (e, vote) ->
      if not vote
        vote =  models.Vote.build
          user_id: 1,
          votingId: req.params.votingID
      vote.preference = req.body.preference
      vote.note = req.body.note
      vote.save().complete (e, saved) ->
        return next(e) if e
        
        req.log.debug
          voting: saved
        res.send 201, saved
