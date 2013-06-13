module.exports = BaseModel = Backbone.Model.extend(
  getAttributes : (keys) ->
    return this.attributes unless keys?

    attributes = if _.isArray(keys) then keys else Array.prototype.slice.apply(arguments)
    pickArgs = [this.attributes].concat(attributes)
    return _.pick.apply(this, pickArgs)

  getSlug : (attribute) ->
    return null unless this.get(attribute)?
    return this.calculateSlug(this.get(attribute))

  calculateSlug : (text) ->
    str = text.replace(/^\s+|\s+$/g, '') # trim
    str = str.toLowerCase()
    
    # remove accents, swap ñ for n, etc
    from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;"
    to   = "aaaaeeeeiiiioooouuuunc------"
    
    str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i)) for i in [0..from.length]

    str = str.replace(/[^a-z0-9 -]/g, '') # remove invalid chars
      .replace(/\s+/g, '-') # collapse whitespace and replace by -
      .replace(/-+/g, '-')  # collapse dashes

    return str;

  getTimeAgo : (attribute) ->
    return null unless this.get(attribute)?
    return this.calculateTimeAgo(this.get(attribute))

  getShortDate : (attribute) ->
    return null unless this.get(attribute)?
    return this.calculateShortDate(this.get(attribute))

  getShortTime : (attribute) ->
    return null unless this.get(attribute)?
    return this.calculateShortTime(this.get(attribute))

  calculateTimeAgo : (dateString) ->
    return null unless dateString and _.isString(dateString)
    
    now = new Date()
    start = new Date(dateString)
    min = ~~((now-start)/60000) #nifty bitwise op to force integer

    return "<1m"           if min < 1
    return "#{min}m"       if min < 60
    return "#{~~(min/60)}h"    if min < 1440  # 60m/h * 24h
    return "#{~~(min/1440)}d"  if min < 10080 # 1440m/d * 7d
    return "#{~~(min/10080)}w" if min < 40320 # 10080m/w * 4w

    # not counting months/years
    this.calculateShortDate(dateString)

  calculateShortDate: (dateString) ->
    dt = new Date(dateString)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"] 
    "#{months[dt.getMonth()]} #{dt.getDate()}"

  calculateShortTime: (dateString) ->
    dt = new Date(dateString)
    mh = dt.getHours()
    hr = if mh%12==0 then 12 else mh%12
    min = if (dt.getMinutes()<10) then "0"+dt.getMinutes() else ""+dt.getMinutes()
    hr + ":" + min + (if mh<12 then " AM" else " PM")

)
