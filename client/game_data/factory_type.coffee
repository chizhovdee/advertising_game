Base = require("./base")

class FactoryType extends Base
  @configure 'FactoryType', 'key', 'basicPrice', 'buildLevel', 'buildDuration',
    'upgradePerLevels', 'baseUpgradeDuration', 'reward', 'requirement',
    'productionDurations', 'producedMaterials', 'consumableMaterials', 'position'

  name: ->
    I18n.t("game_data.factory_types.#{@key}.name")

  description: ->
    I18n.t("game_data.factory_types.#{@key}.description")

  upgradeLevelBy: (factoryLevel)->
    factoryLevel * @upgradePerLevels - (@buildLevel - 1)

  upgradePriceBy: (factoryLevel)->
    (factoryLevel + 1) * @basicPrice

  materialLimitBy: (materialKey, level)->
    for key, limit of _.assignIn({}, @producedMaterials, @consumableMaterials)
      if materialKey == key
        return limit * level

  isContainMaterial: (materialKey)->
    @consumableMaterials[materialKey]? || @producedMaterials[materialKey]?

module.exports = FactoryType