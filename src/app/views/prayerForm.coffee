app         = require('../app.coffee')
# $           = require('jquery'),
# _           = require('underscore'),
# Backbone    = require('backbone'),
# JST         = require('templates');
Prayer      = require('../models/prayer.coffee')

module.exports = Backbone.View.extend(

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
    #$(this.el).trigger('create');
    #app.appView.enableActionButton("Save", "check", this.savePrayer, this);
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
      # app.appView.disableActionButton()

      if this.model.isNew()
        app.prayers.add(this.model)
      
      #$.mobile.loading("show")
      this.model.save(null, {
        trimAttributes: true
        success: (model, res, options) ->
          Backbone.history.navigate('/', {trigger: true})
        error: (model, res, options) =>
          #app.appView.enableActionButton("Save", "check", that.savePrayer, that)
          #$.mobile.loading("hide")
          app.prayers.remove(this.model)
          console.log("Failed to save prayer.")
          console.log(res.status + " " + res.statusText + ": " + res.responseText)
      })
)