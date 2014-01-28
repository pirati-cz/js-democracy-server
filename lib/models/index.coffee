
unless global.hasOwnProperty("db")
  Sequelize = require("sequelize")

  if process.env.POSTGRESQL_URL
    # the application is executed on Heroku ... use the postgres database
    sequelize = new Sequelize(process.env.POSTGRESQL_URL,
      dialect: "postgres"
      protocol: "postgres"
      logging: false
    )
  else
    # the application is executed on the local machine ... use sqlite
    Sequelize = require('sequelize-sqlite').sequelize
    sqlite    = require('sequelize-sqlite').sqlite
    sqliteURL = process.env.SQLITE_URL or ':memory:'

    console.log "Using DB within #{sqliteURL}"
    sequelize = new Sequelize('database', 'username', 'password',
      dialect: 'sqlite'
      storage: sqliteURL
      foreignKeys: false
    )

  Voting = sequelize.import(__dirname + "/voting")
  Option = sequelize.import(__dirname + "/option")
  Vote = sequelize.import(__dirname + "/vote")

  Voting.hasMany(Vote, {foreignKey: 'votingId'})
  Voting.hasMany(Option, {foreignKey: 'votingId'})

  global.db =
    Sequelize: Sequelize
    sequelize: sequelize
    Voting: Voting
    Option: Option
    Vote: Vote

module.exports = global.db


