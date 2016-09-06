BaseRecord = require('./base_record')

class PropertyRecord extends BaseRecord
  isBuilding: ->
    @buildingTimeLeft? && @.actualBuildingTimeLeft() >= 0

  actualBuildingTimeLeft: ->
    @buildingTimeLeft - @.loadedTimeDiff()

  isUpgrading: ->
    @upgradingTimeLeft? && @.actualUpgradingTimeLeft() >= 0

  actualUpgradingTimeLeft: ->
    @upgradingTimeLeft - @.loadedTimeDiff()

module.exports = PropertyRecord