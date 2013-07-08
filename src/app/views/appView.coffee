app = require('../app.coffee')
Vm  = require('../vm.coffee')
CircleList  = require('./circleList.coffee');
#DonateView  = require('./views/donateView')

module.exports = Backbone.View.extend(
  __name__: __filename

  el: 'body'
  events:   
    'click #open-sidepanel' : 'toggleSidePanel'
    'click #sidepanel a' : 'closeSidePanel'
  
  initialize: ->

  render: ->
    # Pass the appView down into the footer so we can render the visualisation
    if app.loggedIn()
      sideBarView = Vm.create(this, 'CircleList', CircleList, {collection : app.circles})
      sidePanelView = Vm.create(this, 'CirclePanel', CircleList, {collection : app.circles, el: '#sidepanel'})
    # else
    #   sideBarView = Vm.create(this, 'DonateView', DonateView, {appView: this})

    sideBarView?.render()
    sidePanelView?.render()

  
  hideRequestPrayerButton: ->
    $('#request-prayer').hide()

  showRequestPrayerButton: ->
    $('#request-prayer').show()

  toggleSidePanel: (evt) ->
    evt.preventDefault()
    if app.snapper.state().state=="left"
      app.snapper.close()
    else
      app.snapper.open('left')

  closeSidePanel: (evt) ->
    # DO NOT preventDefault here
    if app.snapper.state().state=="left"
      app.snapper.close()

)