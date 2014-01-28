
unless global.hasOwnProperty("db")
  Sequelize = require("sequelize")

  if process.env.POSTGRESQL_URL
    # the application is executed on Heroku ... use the postgres database
    match = process.env.POSTGRESQL_URL.match(/postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/)
    sequelize = new Sequelize match[5], match[1], match[2],
      port:     match[4]
      host:     match[3]
      dialect: "postgres"
      logging: false
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


