voting = require('./routes/voting')
vote = require('./routes/vote')


exports.createAPI = (app) ->
  app.get "/votinglist/", voting.getVotinglist

  app.post "/voting/", voting.createVoting
  app.get "/voting/:votingID/", voting.getVoting
  app.put "/voting/:votingID/", voting.updateVoting

  app.post "/vote/:votingID/", vote.doVote

