ctx = require('../context')
gameData = require('../game_data')
MaterialType = gameData.MaterialType
TownLevel = gameData.TownLevel

Town = {
  id: 'town'
  key: 'town'
  resource: 'town'
  position: {x: 0, y: 0}

  levelNumber: ->
    ctx.get('player').town_level

  level: ->
    TownLevel.findByNumber(@.levelNumber())

  type: ->
    @ # возвращает себя самого для абстракции при назначении грузоперевозок

  name: ->
    I18n.t('town.name')

  getMaterialDataForTrucking: (materialKey)->
    playerState = ctx.get('playerState')

    if @.level().isContainMaterial(materialKey)
      currentCount = playerState.getMaterialFor(@resource, materialKey)
      maxCount = @.level().getMaterial(materialKey)

    else
      materialType = MaterialType.find(materialKey)

      unless materialType.lockedBy(@.levelNumber())
        currentCount = playerState.findTownMaterialRecord(materialKey)?.actualValue() || 0
        maxCount = materialType.limitBy(@.levelNumber())

    if currentCount? && maxCount?
      {currentCount: currentCount, maxCount: maxCount}
    else
      null
}

module.exports = Town