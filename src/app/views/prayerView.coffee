app = require('../app.coffee')
Vm  = require('../vm.coffee')
DeletePrompt = require('./deletePrompt.coffee')

module.exports = Backbone.View.extend(
  __name__: __filename

  el: "#content"
  template : JST['prayer']
  events:
    "click #delete-prayer" : "deletePrayer"

  initialize: (options) -> 
    this.model = this.model ? new Prayer()

  render: ->
    prayer = this.model.toJSON()
    prayer.created_at = this.model.getShortDate('created_at') + ", " + this.model.getShortTime('created_at') 

    html = this.template({'prayer': prayer})
    this.$el.html(html);
    
    if this.model.get('author')?._id == app.me.get('_id')
      html =  '<button id="delete-prayer" class="small alert button">Delete</button>' +
              '<a href="/prayers/' + prayer._id + '/edit" class="small button">Edit</a>'
      this.$el.find('#manage-prayer').html(html)
      
    this # maintains chainability

  deletePrayer: (evt) ->
    evt.preventDefault()
    item = { type: "prayer", description: this.model.get('msg') }
    deletePrompt = Vm.create(app.appView, 'DeletePrompt', DeletePrompt, {model : this.model, item})
    deletePrompt.render()

    $('#delete-prompt').foundation('reveal', 'open')




)
