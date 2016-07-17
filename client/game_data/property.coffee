BaseResource = require('./base_resource')

class Property extends BaseResource
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

module.exports = Property