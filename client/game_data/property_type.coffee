Base = require("./base")

class PropertyType extends Base
  @configure 'PropertyType', 'key', 'basicPrice', 'buildLevel', 'buildDuration', 'freeCapacity',
    'baseCapacity', 'upgradePerLevels', 'baseUpgradeDuration', 'rentOutAvailable', 'reward'

  name: ->
    I18n.t("game_data.property_types.#{@key}.name")

  description: ->
    I18n.t("game_data.property_types.#{@key}.description")

  rentOutInfo: ->
    I18n.t("game_data.property_types.#{@key}.rent_out_info")

  upgradeLevelBy: (propertyLevel)->
    propertyLevel * @upgradePerLevels - (@buildLevel - 1)

  upgradePriceBy: (propertyLevel)->
    (propertyLevel + 1) * @basicPrice

module.exports = PropertyType