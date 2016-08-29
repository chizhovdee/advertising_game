Base = require("./base")

class MaterialType extends Base
  @configure 'MaterialType', 'key', 'level'

  name: ->
    I18n.t("game_data.material_types.#{ @key }")

module.exports = MaterialType