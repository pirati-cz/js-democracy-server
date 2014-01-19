models = require('../models')

exports.retrieveVoting = (conds, onFound, onErr) ->
  models.Voting.find(where: conds)
  .success((found) ->
    return onErr('not found') if not found
    onFound(found)
  ).error (err) ->
    onErr(err)

exports.retrieveOptions = (voting, done, onErr) ->
  models.Option.findAll(
    where: {votingId: voting.id},
  ).success((found) ->
    done(found)
  ).error (err) ->
    onErr(err)

exports.saveOptions = (voting, options, done, onErr) ->
  opts = []
  for o, idx in options
    opt = {votingId: voting.id, id: idx}
    for own k, v of o
      opt[k] = v
    opts.push(opt)

  models.Option.bulkCreate(opts)
  .success(->
    done(opts))
  .error(onErr)

