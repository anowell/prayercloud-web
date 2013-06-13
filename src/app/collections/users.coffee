User = require('../models/user.coffee')
 
module.exports = UserCollection = Backbone.Collection.extend(
    url: '/api/friends'
    model: User
    comparator: "displayName"
)