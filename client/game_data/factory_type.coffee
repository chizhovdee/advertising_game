Base = require("./base")

class FactoryType extends Base
  @configure 'FactoryType', 'key', 'basicPrice', 'buildLevel', 'buildDuration',
    'upgradePerLevels', 'baseUpgradeDuration', 'reward', 'requirement'

  name: ->
    I18n.t("game_data.factory_types.#{@key}.name")

  description: ->
    I18n.t("game_data.factory_types.#{@key}.description")

  upgradeLevelBy: (factoryLevel)->
    factoryLevel * @upgradePerLevels - (@buildLevel - 1)

  upgradePriceBy: (factoryLevel)->
    (factoryLevel + 1) * @basicPrice

module.exports = FactoryType