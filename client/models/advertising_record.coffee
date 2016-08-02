BaseRecord = require('./base_record')

class AdvertisingRecord extends BaseRecord
  actualExpireTimeLeft: ->
    @expireTimeLeft - @.loadedTimeDiff()

  isExpired: ->
    @.actualExpireTimeLeft() < 0

  actualNextRouteTimeLeft: ->
    @nextRouteTimeLeft - @.loadedTimeDiff()

  canOpenRoute: ->
    @.actualNextRouteTimeLeft() < 0

module.exports = AdvertisingRecord