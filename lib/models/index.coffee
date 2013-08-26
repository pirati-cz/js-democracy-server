
unless global.hasOwnProperty("db")
  Sequelize = require("sequelize")

  if process.env.HEROKU_POSTGRESQL_BRONZE_URL
    # the application is executed on Heroku ... use the postgres database
    sequelize = new Sequelize(process.env.HEROKU_POSTGRESQL_BRONZE_URL,
      dialect: "postgres"
      protocol: "postgres"
      logging: true #false
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
  Option.hasOne(Voting)
  Vote.hasOne(Voting)

  global.db =
    Sequelize: Sequelize
    sequelize: sequelize
    Voting: Voting
    Option: Option
    Vote: Vote

  #sequelize.sync();

# add your other models here

#
#    Associations can be defined here. E.g. like this:
#    global.db.User.hasMany(global.db.SomethingElse)
#
module.exports = global.db


