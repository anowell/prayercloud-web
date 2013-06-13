BaseModel = require('./base.coffee');

module.exports = User = BaseModel.extend(
  idAttribute: "_id"
  
  initialize: ->

  defaults: 
    displayName : "unnamed"

  validate: (attrs) ->
)

