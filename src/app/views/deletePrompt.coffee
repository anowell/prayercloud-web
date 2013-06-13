# $           = require('jquery'),
# _           = require('underscore'),
# Backbone    = require('backbone'),
# JST         = require('templates');
app = require('../app.coffee')
      

module.exports = Backbone.View.extend(

  el: "#modal"
  template : JST['deletePrompt']
  events:
    "click #cancel-delete" : "cancelDelete"
    "click #confirm-delete" : "confirmDelete"

  initialize: (options) -> 
    this.item = options.item

  render: ->
    html = this.template({'item': this.item})
    
    this.$el.html(html);
    $(this.el).foundation('reveal', 'open')
      
    this # maintains chainability

  cancelDelete: (evt) ->
    evt.preventDefault()
    $(this.el).foundation('reveal', 'close')

  confirmDelete: (evt) ->
    this.model.destroy(
      trimAttributes: true
      success: (model, res, options) =>
        $(this.el).foundation('reveal', 'close')
        Backbone.history.navigate('/', {trigger: true})
      error: (model, res, options) =>
        #$.mobile.loading("hide")
        console.log("Failed to delete item.")
        console.log(res.status + " " + res.statusText + ": " + res.responseText)
    )

)
