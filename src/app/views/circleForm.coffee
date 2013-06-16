app         = require('../app.coffee')
Circle      = require('../models/circle.coffee')

module.exports = Backbone.View.extend(

  el: "#content"
  template : JST['circleForm']
  friendListTemplate : JST['friendList']

  events:
    "input #friend-filter": "filterFriends"
    "click #friend-list [data-id]": "addFollower",
    "click #follower-list [data-id]": "removeFollower",
    "click #save-circle": "saveCircle"

  initialize: (options) ->
    this.model = this.model ? new Circle()

  render: ->
    circle = this.model.toJSON()
    friends = app.friends.toJSON()
    html = this.template({'circle': circle})
    this.$el.html(html)

    if circle.followers?.length > 0
      partial = this.friendListTemplate({friends: circle.followers})
      this.$('#follower-list').html(partial)
    
    this # maintains chainability

  filterFriends: (evt) ->
    evt.preventDefault()
    query = evt.currentTarget.value.toLowerCase()
    return this.$('#friend-list').hide() if query.length < 1

    followerIds = _.pluck(this.model.get('followers'), '_id')
    filteredFriends = app.friends
      .filter((f) => 
        f.get('displayName').toLowerCase().indexOf(query) != -1 and
          not _.contains(followerIds, f.get('_id'))
      )
      .map((f)->f.toJSON())
    return this.$('#friend-list').hide() if filteredFriends.length == 0
    html = this.friendListTemplate({friends: filteredFriends})
    this.$('#friend-list').html(html).show()


  addFollower: (evt) ->
    evt.preventDefault()

    addMe = app.friends.findWhere({_id : evt.currentTarget.getAttribute('data-id') }).getAttributes('_id', 'displayName');
    if this.model.addFollower( addMe._id, addMe.displayName )
      $('#follower-list').prepend(this.friendListTemplate({friends: [addMe]}))

    # Reset search input
    $('input#friend-filter').val("");
    $('input#friend-filter').trigger("input");

  removeFollower: (evt) ->
    evt.preventDefault();
    id = evt.currentTarget.getAttribute('data-id')
    $('#follower-list [data-id='+id+']').remove() if this.model.removeFollower( id )
      
 
  saveCircle: (evt)-> 
    evt.preventDefault()
    form = $('#circle-form').serializeObject()
    
    this.model.set('name', form.name)
    this.model.set('owner', app.me.getAttributes('_id', 'displayName'))

    if this.model.isValid()
      app.circles.add(this.model) if this.model.isNew()
      
      # $.mobile.loading("show");
      this.model.save(null, { 
        trimAttributes: true,
        success: (model, res, options) =>
          Backbone.history.navigate('/circles/' + this.model.get('slug'), {trigger: true})
        error: (model, res, options) => 
          # $.mobile.loading("hide")
          app.circles.remove(this.model)
          console.log("Failed to save circle.")
          console.log(res.status + " " + res.statusText + ": " + res.responseText)
      })
)