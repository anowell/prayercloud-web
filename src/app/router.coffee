#      $         = require('jquery'),
#      Backbone  = require('backbone')
app             = require('./app.coffee')
Vm              = require('./vm.coffee')
Circle          = require('./models/circle.coffee')
PrayerFeed      = require('./views/prayerFeed.coffee')
# CircleListView  = require('./views/circleList.coffee')
PrayerFormView  = require('./views/prayerForm.coffee')
CircleFormView  = require('./views/circleForm.coffee')
CircleView      = require('./views/circleView.coffee')
PrayerView      = require('./views/prayerView.coffee')
LoginPage       = require('./views/login.coffee')


module.exports = Backbone.Router.extend(

  routes: 
    "prayers":              "prayers"
    "prayers/new":          "prayerForm"
    "prayers/:id":          "prayer"
    "prayers/:id/edit":     "prayerForm"
    "circles/:slug/prayers":"prayers"
    "circles":              "circles"
    "circles/new":          "circleForm"
    "circles/:slug":        "circle"
    "circles/:slug/edit" :  "circleForm"
    "login":                "login"
    "logout":               "logout"
    "":                     "index"

  initialize: ->
    # start watching for hashchange events
    Backbone.history.start( 
      pushState : true
      root : app.root
    ) 

  changePage: (options, renderCb) ->
    # $.mobile.loading("show")
    # app.appView.disableActionButton()

    defaults = { auth : true }
    options = _.extend({}, defaults, options)

    if options.auth and not app.loggedIn()
      return this.navigate('login', {trigger: true, replace: true})

    if app.snapper?.state()?.state=="left"
      app.snapper.close()

    # transition out
    app.appView.showRequestPrayerButton()
    renderCb()
    # transition in
    # $.mobile.loading("hide");

  index: ->
    this.prayers();

  prayers: (slug) ->
    this.changePage(null, ->
      if slug == "private"
        circle = new Circle({name: "Private"})
        prayers = app.prayers.wherePrivate()
      else if slug?
        circle = app.circles.findBySlug(slug)
        prayers = app.prayers.whereShared(circle)
      else
        circle = new Circle({name: "All prayers"})
        prayers = app.prayers.models

      prayerFeed = Vm.create(app.appView, 'PrayerFeed', PrayerFeed, {collection : prayers, model : circle})
      prayerFeed.render()
    )

  prayer: (id) ->
    this.changePage(null, ->
      prayer = app.prayers.findWhere({_id : id })
      prayerView = Vm.create(app.appView, 'PrayerView', PrayerView, {model : prayer})
      prayerView.render()
    )

  prayerForm: (id) ->
    this.changePage(null, ->
      app.appView.hideRequestPrayerButton()
      prayer = app.prayers.findWhere({_id : id })
      prayerForm = Vm.create(app.appView, 'PrayerForm', PrayerFormView, {model : prayer})
      prayerForm.render()
    )

  # circles: ->
  #   this.changePage(null, ->
  #     circleList = Vm.create(app.appView, 'CircleList', CircleListView, {collection : app.circles})
  #     circleList.render()
  #   )

  circle: (slug) ->
    this.changePage(null, ->
      circle = app.circles.findBySlug(slug);
      circleView = Vm.create(app.appView, 'CircleView', CircleView, {model : circle})
      circleView.render()
    )

  circleForm: (slug) ->
    this.changePage(null, ->
      circle = app.circles.findBySlug(slug)
      circleForm = Vm.create(app.appView, 'CircleForm', CircleFormView, {model : circle})
      circleForm.render()
    )

  login: ->
    this.changePage({auth: false}, ->
      app.appView.hideRequestPrayerButton()
      loginPage = Vm.create(app.appView, 'LoginPage', LoginPage)
      loginPage.render()
    )

  logout: ->
    location.href = "/logout"

)