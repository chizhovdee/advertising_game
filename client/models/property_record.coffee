BaseRecord = require('./base_record')

class PropertyRecord extends BaseRecord
  isBuilding: ->
    @buildingTimeLeft? && @.actualBuildingTimeLeft() >= 0

  actualBuildingTimeLeft: ->
    @buildingTimeLeft - @.timeDiff()

  isUpgrading: ->
    @upgradingTimeLeft? && @.actualUpgradingTimeLeft() >= 0

  isRented: ->
    # достаточно проверки одного поля
    @rentTimeLeft?

  actualUpgradingTimeLeft: ->
    @upgradingTimeLeft - @.timeDiff()

  actualRentTimeLeft: ->
    @rentTimeLeft - @.timeDiff()

  rentFinished: ->
    @.actualRentTimeLeft() < 0

module.exports = PropertyRecord