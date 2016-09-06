Base = require("./base")

class PropertyType extends Base
  @configure 'PropertyType', 'key', 'basicPrice', 'buildLevel', 'buildDuration', 'freeCapacity',
    'baseCapacity', 'upgradePerLevels', 'baseUpgradeDuration'

  name: ->
    I18n.t("game_data.property_types.#{@key}.name")

  description: ->
    I18n.t("game_data.property_types.#{@key}.description")

  upgradeLevelBy: (propertyLevel)->
    propertyLevel * @upgradePerLevels - (@buildLevel - 1)

  upgradePriceBy: (propertyLevel)->
    (propertyLevel + 1) * @basicPrice

  fullCapacityBy: (property)->
    @.capacityByLevel(property?.level || 0) + @freeCapacity

  capacityByLevel: (level)->
    @baseCapacity * level

module.exports = PropertyType