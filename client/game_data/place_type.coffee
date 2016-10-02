Base = require("./base")

class PlaceType extends Base
  @configure 'PlaceType', 'key', 'position'

  name: ->
    I18n.t("game_data.place_types.#{ @key }.name")

module.exports = PlaceType