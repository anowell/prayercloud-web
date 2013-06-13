Circle = require('../models/circle.coffee')

module.exports = CircleCollection = Backbone.Collection.extend(
  url: '/api/circles'
  model: Circle
  comparator: "name"

  findBySlug : (slug) ->
    this.findWhere({slug: slug})
)