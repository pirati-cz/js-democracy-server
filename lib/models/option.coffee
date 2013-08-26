
###
Represents one option within a voting.
url points to referrence material to this option.
###
module.exports = (sequelize, DataTypes) ->
  sequelize.define "Option",
    id: DataTypes.BIGINT,
    name: DataTypes.STRING(64),
    desc: DataTypes.STRING,
    url: DataTypes.STRING