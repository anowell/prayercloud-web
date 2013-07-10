app               = require('./app.coffee')
Vm                = require('./vm.coffee')
AppView          = require('./views/appView.coffee')
Router            = require('./router.coffee')


$(document).foundation()

# Cleanup URL from facebook redirect
if window.location.hash == '#_=_'
  window.location.hash = ''
  history.pushState('', document.title, window.location.pathname)


app.me.fetch(
  async : false, 
  success : (usr, res, opt) ->
    console.log("Logged in as " + app.me.get('displayName'))
    app.sync({async : false})
  error : (usr, res, opt) ->
    console.log("Not yet logged in.")
)

app.appView = Vm.create({}, 'AppView', AppView)
app.appView.render();

app.router = new Router()

# All navigation that is relative should be processed by the router.
$(document).on("click", "a[href]", (evt) ->
  href = { prop: $(this).prop("href"), attr: $(this).attr("href") }
  root = location.protocol + "//" + location.host + app.root;

  # Ensure the root is part of the anchor href, meaning it's relative.
  if href.prop.slice(0, root.length) == root
    evt.preventDefault();
    Backbone.history.navigate(href.attr, true) unless href.attr == '#'
)
