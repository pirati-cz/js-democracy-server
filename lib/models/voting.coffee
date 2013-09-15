
###
Represents one voting.
url: url with discussion about this voting, citations, more info.
###
module.exports = (sequelize, DataTypes) ->
  sequelize.define "voting",
    name:
      type: DataTypes.STRING(64),
      allowNull: false,
    desc: DataTypes.STRING,
    url:
      type: DataTypes.STRING,
      isUrl: true
    begin:
      type: DataTypes.DATE,
      allowNull: false,
    end:
      type: DataTypes.DATE,
      allowNull: false,
    category_id:
      type: DataTypes.BIGINT,
      allowNull: false,