Base = require("./base")

class TransportType extends Base
  @configure 'TransportType', 'key'

  name: ->
    I18n.t("game_data.transport_types.#{ @key }")

module.exports = TransportType