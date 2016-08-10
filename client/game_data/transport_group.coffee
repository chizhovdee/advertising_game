Base = require("./base")

class TransportGroup extends Base
  @configure 'TransportGroup', 'key', 'level'

  name: ->
    I18n.t("game_data.transport_groups.#{ @key }")

module.exports = TransportGroup