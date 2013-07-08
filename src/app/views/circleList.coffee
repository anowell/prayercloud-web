CircleCollection  = require('../collections/circles.coffee')

module.exports = Backbone.View.extend(
  __name__: __filename

  el: "#sidebar"
  template : JST["circleList"]

  events: {}

  initialize: (options) ->
    this.collection.on('add', this.render, this)
    this.collection.on('remove', this.render, this)
    this.collection.on('reset', this.render, this)

  render: ->
    circles = this.collection.toJSON()

    html = this.template({ circles : circles })
    this.$el.html(html);

    this # maintains chainability
)