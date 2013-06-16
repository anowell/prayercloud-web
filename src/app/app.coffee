PrayerCollection  = require('./collections/prayers.coffee')
CircleCollection  = require('./collections/circles.coffee')
UserCollection    = require('./collections/users.coffee')
User              = require('./models/user.coffee')
Circle            = require('./models/circle.coffee')

app = 
  appView: {}
  root: "/"

app.me = new User( {}, {url : '/api/me' } )
  
app.prayers = new PrayerCollection()
app.circles = new CircleCollection()
app.friends = new UserCollection()

app.loggedIn = () -> !app.me.isNew()

app.sync = (options) ->
  this.prayers.fetch(options)
  this.circles.fetch(options)
  this.friends.fetch(options)
  console.log("Fetched all collections")

module.exports = app