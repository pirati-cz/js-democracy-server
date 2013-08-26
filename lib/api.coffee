voting = require('./routes/voting')
options = require('./routes/options')
vote = require('./routes/vote')

module.exports = 
  createRoutes: (server) ->
    ### voting
    GET /votinglist/ Lists all votings which authenticated (or delegated) user can vote.
    POST /voting/ Creates a new voting according request data (admin only).
    GET /voting/:votingID/ Retrieves all informations abount given voting
    PUT /voting/:votingID/ Updates a new voting according request data (admin only).
    ###
    #server.use handlers.loadTodos
    server.get "/votinglist", voting.getVotinglist
    server.post "/voting", voting.createVoting
    server.get "/voting/:votingID", voting.getVoting
    server.put
      path: "/voting/:votingID"
      contentType: "application/json"
    , voting.updateVoting
    
    # everything else requires that the TODO exist
    #server.use handlers.ensureTodo
    
    ### options
    POST /options/:votingID/ Creates another option within given voting (only before voting begins).
    PUT /options/:votingID:optionID/ Updates given option within given voting (only before voting begins).
    DELETE /options/:votingID/:optionID/ Removes given option from given voting (only before voting begins).
    ###
    #server.get "/todo/:name", handlers.getTodo
    server.post
      path: "/options/:votingID",
      contentType: "application/json"
    , options.createOption
    server.put
      path: "/options/:votingID:optionID",
      contentType: "application/json"
    , options.updateOption
    server.del "/options/:votingID/:optionID/", options.deleteOption
    
    
    ### vote
    PUSH /vote/:votingID/:optionID/
    ###
    server.post "/vote/:votingID/:optionID/", vote.doVote

