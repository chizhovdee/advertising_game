_ = require("lodash")
PlaceType = require('../game_data').PlaceType

PlaceType.define('town', (obj)-> obj.position = {x: 0, y: 0})
