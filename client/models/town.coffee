ctx = require('../context')
gameData = require('../game_data')
MaterialType = gameData.MaterialType
TownLevel = gameData.TownLevel
PlaceType = gameData.PlaceType

PlaceRecord = require('./place_record')

town = new PlaceRecord(id: 'town', placeTypeKey: 'town')

_.assignIn town, {
  levelNumber: ->
    ctx.get('player').town_level

  level: ->
    TownLevel.findByNumber(@.levelNumber())

  canUpgrade: ->
    level = @.level()

    return false if _.isEmpty(level.materials)

    resource = ctx.get('playerState').getResourceFor(@)

    for materialKey, maxCount of level.materials
      return false if maxCount > ctx.get('playerState').getMaterialFor(resource, materialKey)

    true

  getMaterialDataForTrucking: (materialKey)->
    playerState = ctx.get('playerState')
    level = @.level()

    if level.isContainMaterial(materialKey)
      currentCount = playerState.getMaterialFor(ctx.get('playerState').getResourceFor(@), materialKey)
      maxCount = level.getMaterial(materialKey)

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

module.exports = town