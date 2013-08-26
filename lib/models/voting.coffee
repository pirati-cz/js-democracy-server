
###
Represents one voting.
url: url with discussion about this voting, citations, more info.
###
module.exports = (sequelize, DataTypes) ->
  sequelize.define "voting",
    id:
      type: DataTypes.BIGINT,
      autoIncrement: true
    name: DataTypes.STRING(64),
    desc: DataTypes.STRING,
    url:
      type: DataTypes.STRING,
      isUrl: true
    begin: DataTypes.DATE,
    end: DataTypes.DATE,
    category_id: DataTypes.BIGINT