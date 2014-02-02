
createModels = (mongoose) ->

  ###
  Represents one option within a voting.
  url points to referrence material to this option.
  ###
  optionSchema = mongoose.Schema
    name:
      type: String
      required: true
    desc: String
    url: String

  ###
  Represents one voting.
  url: url with discussion about this voting, citations, more info.
  ###
  votingSchema = mongoose.Schema
    name:
      type: String
      required: true
    desc: String
    url:
      type: String
      isUrl: true
    begin:
      type: Date
    end:
      type: Date
    category_id:
      type: Number
      required: true
    opts:
      type: [optionSchema]
      required: true

  ###
  Represents one vote of user_id within voting_id.
  preference is JSON serialized answer depending on voting.type.
  ###
  voteSchema = mongoose.Schema
    user_id: String
    preference: String
    note: String

  # return:
  Voting: mongoose.model('Votings', votingSchema)
  Vote: mongoose.model('Votes', voteSchema)

# ---------------------------------------

module.exports = (done) ->

  mongoose = require('mongoose')

  uri = process.env.MONGO_URI || 'mongodb://localhost/test'

  mongoose.connect uri, (err, conn) ->
    return done(err) if err

    models = createModels(mongoose)
    done(null, models)
