Prayer      = require('../models/prayer.coffee')

  
module.exports = Backbone.Collection.extend(
  url: '/api/prayers'
  model: Prayer

  comparator: (a, b) ->
    # Reverse order of _id which is timestamp-derived
    aid = a.get('_id');
    bid = b.get('_id');
    
    # Ensure new prayers (lacking ID) are at top
    return 0  if !aid and !bid
    return -1 if !aid  # a before b
    return 1  if(!bid) # b before a

    # Act
    return -1 if aid > bid # a before b
    return 1  if bid > aid # b before a
    return 0

  whereShared : (circle) ->
    return [] unless circle?
    
    return this.filter((prayer) -> 
      circleIds = _.pluck(prayer.get('circles'), '_id')
      return _.contains(circleIds, circle.get('_id'))
    )

  wherePrivate : ->
    return this.filter((prayer) -> prayer.get("circles").length == 0)

)
