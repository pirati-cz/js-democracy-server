
errors = require('../errors')
models = require('../models')


###
POST /options/:votingID/
Creates another option within given voting (only before voting begins).
###
exports.createOption = (req, res, next) ->
  res.send 200, "createOption"
  next()

###
PUT /options/:votingID:optionID/
Updates given option within given voting (only before voting begins).
###
exports.updateOption = (req, res, next) ->
  res.send 200, "updateOption"
  next()

###
DELETE /options/:votingID/:optionID/
Removes given option from given voting (only before voting begins).
###
exports.deleteOption = (res, req, next) ->
  res.send 200, "deleteOption"
  next()

  