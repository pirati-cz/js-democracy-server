
###
Represents one option within a voting.
url points to referrence material to this option.
###
module.exports = (sequelize, DataTypes) ->
  sequelize.define "Option",
    id:
      type: DataTypes.INTEGER
      allowNull: false
    name: 
      type: DataTypes.STRING
      allowNull: false
    desc: DataTypes.STRING
    url: DataTypes.STRING    