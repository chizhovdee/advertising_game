BaseRecord = require('./base_record')
PlaceType = require('../game_data').PlaceType

class PlaceRecord extends BaseRecord
  type: ->
    @_type ?= PlaceType.find(@placeTypeKey)

module.exports = PlaceRecord