BaseResource = require('./base_resource')

class Property extends BaseResource
  isBuilding: ->
    @buildingTimeLeft? && @.actualBuildingTimeLeft() > 0

  actualBuildingTimeLeft: ->
    @buildingTimeLeft - @.timeDiff()

module.exports = Property