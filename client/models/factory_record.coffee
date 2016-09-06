BaseRecord = require('./base_record')

class FactoryRecord extends BaseRecord
  isBuilding: ->
    @buildingTimeLeft? && @.actualBuildingTimeLeft() >= 0

  actualBuildingTimeLeft: ->
    @buildingTimeLeft - @.loadedTimeDiff()

  isUpgrading: ->
    @upgradingTimeLeft? && @.actualUpgradingTimeLeft() >= 0

  actualUpgradingTimeLeft: ->
    @upgradingTimeLeft - @.loadedTimeDiff()

  inProduction: ->
    @productionTimeLeft? && @.actualProductionTimeLeft() >= 0

  canCollectProduction: ->
    @productionTimeLeft? && @.actualProductionTimeLeft() < 0

  actualProductionTimeLeft: ->
    @productionTimeLeft - @.loadedTimeDiff()

module.exports = FactoryRecord