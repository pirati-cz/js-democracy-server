voting = require('./routes/voting')
options = require('./routes/options')
vote = require('./routes/vote')


exports.createAPI = (app) ->
  ### voting
  GET /votinglist/ Lists all votings which authenticated (or delegated) user can vote.
  POST /voting/ Creates a new voting according request data (admin only).
  GET /voting/:votingID/ Retrieves all informations abount given voting
  PUT /voting/:votingID/ Updates a new voting according request data (admin only).
  ###

  app.get "/votinglist/", voting.getVotinglist
  app.post "/voting/", voting.createVoting
  app.get "/voting/:votingID/", voting.getVoting
  app.put "/voting/:votingID/", voting.updateVoting
  
  # everything else requires that the TODO exist
  #app.use handlers.ensureTodo
  
  ### options
  POST /options/:votingID/ Creates another option within given voting (only before voting begins).
  PUT /options/:votingID/:optionID/ Updates given option within given voting (only before voting begins).
  DELETE /options/:votingID/:optionID/ Removes given option from given voting (only before voting begins).
  ###
  app.post "/options/:votingID/", options.createOption
  app.put "/options/:votingID/:optionID", options.updateOption
  app.delete "/options/:votingID/:optionID", options.deleteOption  
  
  ### vote
  POST /vote/:votingID/
  ###
  app.post "/vote/:votingID/", vote.doVote

