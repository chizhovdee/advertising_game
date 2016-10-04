BaseRecord = require('./base_record')

class TownMaterialRecord extends BaseRecord
  actualTimeLeftToLimit: ->
    @timeLeftToLimit - @.loadedTimeDiff()

  isDeliveredToday: ->
    @.actualTimeLeftToLimit() > 0

  actualValue: ->
    if @.isDeliveredToday()
      @value
    else
      0

module.exports = TownMaterialRecord