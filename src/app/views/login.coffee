app = require('../app.coffee')

# $           = require('jquery'),
# _           = require('underscore'),
# Backbone    = require('backbone'),
# JST         = require('templates');

module.exports = Backbone.View.extend(

  el: "#content"
  template : JST['login'],

  events:
    "click #login" : "login"

  initialize: ->

  render: ->
    html = this.template();
    this.$el.html(html);
    
    this # maintains chainability

  login: ->
    # Let's just use the server's session-based authentication
    location.href = '/auth/facebook'
)