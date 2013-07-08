app         = require('../app.coffee')
Prayer      = require('../models/prayer.coffee')

module.exports = Backbone.View.extend(
  __name__: __filename

  el: "#content"
  
  template : JST['prayerForm']

  events:
    "click #save-prayer" : "savePrayer"


  initialize: (options) ->
    this.model = this.model ? new Prayer()

  render: ->
    prayer = if this.model? then this.model.attributes else null
    html = this.template({'prayer': prayer, 'circles': app.circles.toJSON()})
    
    this.$el.html(html)
    this # maintains chainability

  savePrayer: (evt) ->
    evt.preventDefault()
    # app.appView.disableActionButton()
    form = $('#prayer-form').serializeObject()
    circles =_(app.circles.models)
      .filter((c) -> _.contains(form.circles, c.get('_id')) )
      .map((c) -> c.getAttributes('_id', 'name') )
      .value()
  
    this.model.set('msg', form.msg)
    this.model.set('circles', circles)
    this.model.set('circles', circles)
    this.model.set('author', app.me.getAttributes('_id', 'displayName'))


    if this.model.isValid()

      if this.model.isNew()
        app.prayers.add(this.model)
      
      #$.mobile.loading("show")
      this.model.save(null, {
        trimAttributes: true
        success: (model, res, options) ->
          Backbone.history.navigate('/', {trigger: true})
        error: (model, res, options) =>
          #$.mobile.loading("hide")
          app.prayers.remove(this.model)
          console.log("Failed to save prayer.")
          console.log(res.status + " " + res.statusText + ": " + res.responseText)
      })
)