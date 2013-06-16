app = require('../app.coffee')

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