BaseResource = require('./base_resource')

class Property extends BaseResource
  isBuilding: ->
    @buildingTimeLeft? && @.actualBuildingTimeLeft() > 0

  actualBuildingTimeLeft: ->
    @buildingTimeLeft - @.timeDiff()

  isUpgrading: ->
    @upgradingTimeLeft? && @.actualUpgradingTimeLeft() > 0

  actualUpgradingTimeLeft: ->
    @upgradingTimeLeft - @.timeDiff()

module.exports = Property