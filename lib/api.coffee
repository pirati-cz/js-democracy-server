

exports.createAPI = (app, models) ->

  votingR = require('./routes/voting')(models)
  voteR = require('./routes/vote')(models)

  app.get "/voting", votingR.getVotinglist
  app.post "/voting", votingR.createVoting
  app.get "/voting/:votingID", votingR.findVoting, votingR.getVoting
  app.put "/voting/:votingID", votingR.findVoting, votingR.updateVoting

  app.post "/vote/:votingID", voteR.doVote

