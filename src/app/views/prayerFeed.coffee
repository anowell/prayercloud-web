PrayerCollection  = require('../collections/prayers.coffee')

module.exports = Backbone.View.extend(

    el: "#content"
    
    template : JST['prayerFeed']

    events:
      "click .prayer" : "viewPrayer"


    initialize: (options) ->
      this.model = this.model ? new Circle({ name: 'All Prayers' })

    render: ->
      prayers = _.map(this.collection, (prayer) -> prayer.toJSON())
      circle = this.model.toJSON()

      html = this.template({'prayers' : prayers, 'circle' : circle})
      this.$el.html(html)

      unless this.model.isNew()
        html = '<a href="/circles/' + this.model.get('slug') + '" class="small button">Details</a>'
        this.$el.find('#view-circle').html(html)

      this # maintains chainability

    viewPrayer: (evt) ->
      evt.preventDefault()
      Backbone.history.navigate("prayers/" + evt.currentTarget.getAttribute('data-id'), {trigger: true})


)
