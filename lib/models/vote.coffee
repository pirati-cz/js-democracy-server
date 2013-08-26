
###
Represents one vote of user_id for chosen_option_id within voting_id.
###
module.exports = (sequelize, DataTypes) ->
  sequelize.define "Vote",
    voting_id: DataTypes.BIGINT,
    user_id: DataTypes.BIGINT,
    chosen_option_id: DataTypes.BIGINT,
    issued: DataTypes.DATE