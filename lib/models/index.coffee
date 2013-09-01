
unless global.hasOwnProperty("db")
  Sequelize = require("sequelize")

  if process.env.POSTGRESQL_URL
    # the application is executed on Heroku ... use the postgres database
    sequelize = new Sequelize(process.env.POSTGRESQL_URL,
      dialect: "postgres"
      protocol: "postgres"
    )
  else
    # the application is executed on the local machine ... use sqlite
    Sequelize = require('sequelize-sqlite').sequelize
    sqlite    = require('sequelize-sqlite').sqlite

    sequelize = new Sequelize('database', 'username', 'password',
      dialect: 'sqlite',
      storage: __dirname + '/../database.sqlite',
      foreignKeys: false
    )

  Voting = sequelize.import(__dirname + "/voting")
  Option = sequelize.import(__dirname + "/option")
  Vote = sequelize.import(__dirname + "/vote")

  # create relationships
  Voting.hasMany(Vote, {as: 'Votes'})

  global.db =
    Sequelize: Sequelize
    sequelize: sequelize
    Voting: Voting
    Option: Option
    Vote: Vote

module.exports = global.db


