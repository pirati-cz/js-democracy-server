


module.exports = (models) ->

  ###
  POST /vote/:votingID/
  Actually votes for given option og given voting.
  If there is already voted, the record will be updated.
  ###
  doVote = (req, res, next) ->
    models.Voting.count {_id: req.params.votingID}, (err, count) ->
      return next(404) if err || count == 0

      q = models.Vote.findOne
        user_id: 1, # TODO: get user_id from req
        votingId: req.params.votingID

      q.exec (err, vote) ->
        if not vote
          vote =  new models.Vote
            user_id: 1,
            votingId: req.params.votingID
            preference: req.body.preference
            note: req.body.note

        vote.save (err) ->
          return next(err) if err

          req.log.debug
            vote: vote
          res.send 201, vote

  doVote: doVote
