BaseRecord = require('./base_record')

class PropertyRecord extends BaseRecord
  isBuilding: ->
    @buildingTimeLeft? && @.actualBuildingTimeLeft() >= 0

  actualBuildingTimeLeft: ->
    @buildingTimeLeft - @.loadedTimeDiff()

  isUpgrading: ->
    @upgradingTimeLeft? && @.actualUpgradingTimeLeft() >= 0

  isRented: ->
    # достаточно проверки одного поля
    @rentTimeLeft?

  actualUpgradingTimeLeft: ->
    @upgradingTimeLeft - @.loadedTimeDiff()

  actualRentTimeLeft: ->
    @rentTimeLeft - @.loadedTimeDiff()

  rentFinished: ->
    @.actualRentTimeLeft() < 0

module.exports = PropertyRecord