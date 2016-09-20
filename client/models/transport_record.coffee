BaseRecord = require('./base_record')
TransportModel = require('../game_data').TransportModel

class TransportRecord extends BaseRecord
  model: ->
    @_model ?= TransportModel.find(@transportModelId)

module.exports = TransportRecord