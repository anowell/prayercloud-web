app         = require('../app.coffee')
# $           = require('jquery'),
# _           = require('underscore'),
# Backbone    = require('backbone'),
# JST         = require('templates');
Vm  = require('../vm.coffee')
DeletePrompt = require('./deletePrompt.coffee')
      

module.exports = Backbone.View.extend(
  el: "#content",
  template : JST['circle']
  friendListTemplate : JST['friendList']
  
  events:
    "click #delete-circle" : "deleteCircle"

  initialize: (options) ->
    this.model = this.model ? new Circle()

  render: () ->
    circle = this.model.toJSON()
    html = this.template({'circle': circle})
    
    this.$el.html(html)
    ownerHtml = this.friendListTemplate({friends: [circle.owner]})
    this.$el.html(html)
    this.$el.find('#owner').html(ownerHtml)

    if circle.followers.length > 0
      partial = this.friendListTemplate({friends: circle.followers})
      this.$el.find('#follower-list').html(partial)


    if this.model.get('owner')?._id == app.me.get('_id')
      html =  '<button id="delete-circle" class="small alert button">Delete</button>' +
              '<a href="/circles/' + circle.slug + '/edit" class="small button">Edit</a>'
      this.$el.find('#manage-circle').html(html)
    
    this # maintains chainability

  deleteCircle: (evt) ->
    evt.preventDefault()
    item = { type: "circle", description: this.model.get('name') }
    deletePrompt = Vm.create(app.appView, 'DeletePrompt', DeletePrompt, {model : this.model, item})
    deletePrompt.render()

    $('#delete-prompt').foundation('reveal', 'open')

)