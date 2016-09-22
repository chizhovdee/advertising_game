BaseRecord = require('./base_record')
ctx = require('../context')

class TruckingRecord extends BaseRecord
  isCompleted: ->
    @.actualCompleteIn() <= 0

  actualCompleteIn: ->
    @completeIn - @.loadedTimeDiff()

  destination: ->
    @_destination ?= (
      ctx.get('playerState').findRecordByResource(
        type: @destinationType, id: @destinationId
      )
    )

module.exports = TruckingRecord