Base = require("./base")
ctx = require("../context")

class MaterialType extends Base
  @configure 'MaterialType', 'key', 'townLevel', 'sellBasicPrice'

  name: ->
    I18n.t("game_data.material_types.#{ @key }")

  lockedBy: (townLevel)->
    @townLevel > townLevel

  limitBy: (townLevel)->
    if @townLevel > townLevel
      0

    else
      settings = ctx.get('settings')

      settings.townLevel.basicMaterialLimit +
      settings.townLevel.basicMaterialLimit * (townLevel - @townLevel) *
      settings.townLevel.materialLimitFactor

module.exports = MaterialType