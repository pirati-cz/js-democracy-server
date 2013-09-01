
errors = require('../errors')
models = require('../models')


###
POST /options/:votingID/
Creates another option within given voting (only before voting begins).
###
exports.createOption = (req, res, next) ->
  v = models.Option.build(req.body)
  v.votingId = req.params.votingID
  v.save().success((saved) ->
    req.log.debug
      voting: saved
    res.send 201, saved
  ).error (err) ->
    next(err)

###
PUT /options/:votingID/:optionID/
Updates given option within given voting (only before voting begins).
###
exports.updateOption = (req, res, next) ->
  models.Voting.find(
    where: {id: req.params.votingID}
  ).success((voting) ->    
    models.Option.find(
      where: 
        id: req.params.optionID,
        votingId: voting.id
    ).success((option) ->
      option.updateAttributes(req.body).success((updated) ->
        res.send 200, updated
      ).error (err) ->
        next(err)
    ).error (err) ->
      next(err)
  ).error (err) ->
    next(err)

###
DELETE /options/:votingID/:optionID/
Removes given option from given voting (only before voting begins).
###
exports.deleteOption = (req, res, next) ->
  models.Voting.find(
    where: {id: req.params.votingID}
  ).success((voting) ->
    # TODO: ensure voting.begin > now()
    models.Option.find(
      where: 
        id: req.params.optionID,
        votingId: voting.id
    ).success((option) ->
      option.destroy().success( ->
        res.send 204
      ).error (err) ->
        next(err)
    ).error (err) ->
      next(err)
  ).error (err) ->
    next(err)

  