
###
Represents one vote of user_id within voting_id.
preference is JSON serialized answer depending on voting.type.
###
module.exports = (sequelize, DataTypes) ->
  sequelize.define "Vote",
    user_id: DataTypes.BIGINT
    preference: DataTypes.STRING
    note: DataTypes.STRING