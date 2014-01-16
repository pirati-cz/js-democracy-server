voting = require('./routes/voting')
options = require('./routes/options')
vote = require('./routes/vote')


exports.createAPI = (app) ->
  app.get "/votinglist/", voting.getVotinglist
  app.post "/voting/", voting.createVoting
  app.get "/voting/:votingID/", voting.getVoting
  app.put "/voting/:votingID/", voting.updateVoting

  app.post "/options/:votingID/", options.createOption
  app.put "/options/:votingID/:optionID", options.updateOption
  app.delete "/options/:votingID/:optionID", options.deleteOption

  app.post "/vote/:votingID/", vote.doVote

