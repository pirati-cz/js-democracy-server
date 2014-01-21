models = require('../models')

exports.retrieveVoting = (conds, cb) ->
  models.Voting.find(where: conds).complete(cb)

exports.retrieveOptions = (voting, cb) ->
  models.Option.findAll(where: {votingId: voting.id}).complete(cb)

exports.saveOptions = (voting, options, cb) ->
  opts = []
  for o, idx in options
    opt = {votingId: voting.id, id: idx}
    for own k, v of o
      opt[k] = v
    opts.push(opt)

  models.Option.bulkCreate(opts).complete cb

