Events    = require('./events.coffee')

views = {};

exports.create = (context, name, View, options) ->
  # View clean up isn't actually implemented yet but will simply call .clean, .remove and .unbind
  if views[name]?
    views[name].undelegateEvents()
    views[name].clean() if typeof views[name].clean == 'function'
  
  throw("Error with View: " + name) unless View?
  
  view = new View(options)
  views[name] = view
  
  context.children = {} unless context.children?
  
  context.children[name] = view;
  context.children[name] = view;

  Events.trigger('viewCreated');
  view;

exports.getView = (name) ->
  views[name]