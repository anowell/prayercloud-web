BaseModel = require('./base.coffee')

module.exports = Prayer = BaseModel.extend(
    idAttribute: "_id"

    initialize: ->
      this.updateTimeAgo()
      this.on("change:created_at", this.updateTimeAgo)

      this.updateCircleSlugs()
      this.on("change:circles", this.updateCircleSlugs)

    defaults: {}

    updateTimeAgo: ->
      this.set('timeAgo', this.getTimeAgo('created_at'))
      # setTimeout(updateTimeAgo, 60000) if this.get('timeAgo').match(/m$/)

    updateCircleSlugs: ->
      _.each(this.attributes.circles, (circle) =>
        circle.slug = this.calculateSlug(circle.name)
      )

    validate: (attrs) ->


    toJSON: (options) ->
      json = _.clone(this.attributes)

      if options?.trimAttributes?
        delete json.author
        delete json.timeAgo
        json.circles = _.pluck(json.circles, '_id')

      json
)