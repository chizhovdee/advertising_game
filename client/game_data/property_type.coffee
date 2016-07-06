Base = require("./base")

class PropertyType extends Base
  @configure 'PropertyType', 'key', 'basicPrice', 'buildLevel', 'buildDuration',
    'baseCapacity', 'upgradePerLevels', 'upgradeDuration'

  name: ->
    I18n.t("game_data.property_types.#{@key}")

  upgradeLevelBy: (propertyLevel)->
    propertyLevel * @upgradePerLevels - @buildLevel - 1

module.exports = PropertyType