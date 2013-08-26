restify = require("restify")
util = require("util")
assert = require("assert-plus")

#/--- Errors

MissingTaskError = ->
  restify.RestError.call this,
    statusCode: 409
    restCode: "MissingTask"
    message: "\"task\" is a required parameter"
    constructorOpt: MissingTaskError

  @name = "MissingTaskError"
  
util.inherits MissingTaskError, restify.RestError


TodoExistsError = (name) ->
  assert.string name, "name"
  restify.RestError.call this,
    statusCode: 409
    restCode: "TodoExists"
    message: name + " already exists"
    constructorOpt: TodoExistsError

  @name = "TodoExistsError"
  
util.inherits TodoExistsError, restify.RestError


TodoNotFoundError = (name) ->
  assert.string name, "name"
  restify.RestError.call this,
    statusCode: 404
    restCode: "TodoNotFound"
    message: name + " was not found"
    constructorOpt: TodoNotFoundError

  @name = "TodoNotFoundError"

util.inherits TodoNotFoundError, restify.RestError


module.exports =
  MissingTaskError: MissingTaskError
  TodoExistsError: TodoExistsError
  TodoNotFoundError: TodoNotFoundError