Base = require("./base")

class MaterialType extends Base
  @configure 'MaterialType', 'key', 'townLevel'

  name: ->
    I18n.t("game_data.material_types.#{ @key }")

  lockedBy: (townLevel)->
    @townLevel > townLevel

module.exports = MaterialType