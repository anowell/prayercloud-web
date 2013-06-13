BaseModel = require('./base.coffee')

module.exports = Circle = BaseModel.extend(
  
  idAttribute: "_id"

  initialize: ->
    this.updateSlug()
    this.on("change:name", this.updateSlug)

  defaults: {}

  updateSlug: ->
    this.set('slug', this.getSlug('name'))

  findFollowerById: (id) ->
    _.find(this.get('followers'), (f)-> f._id == id)

  addFollower: (id, displayName) ->
    return false unless id? and displayName? and not this.findFollowerById(id)

    followers = this.get('followers') ? []
    followers.push({_id: id, displayName: displayName})
    this.set('followers', followers)
    true

  removeFollower: (id) ->
    return false unless this.findFollowerById(id)

    followers = _.filter(this.get('followers'), (f) -> f._id != id )
    this.set('followers', followers)
    true

  validate: (attrs) ->

  toJSON: (options) ->
    json = _.clone(this.attributes)

    if options?.trimAttributes?
      delete json.slug
      json.followers = _.pluck(json.followers, '_id')
      json.owner = json.owner._id
    
    json
)