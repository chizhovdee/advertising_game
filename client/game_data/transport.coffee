Base = require("./base")

class Transport extends Base
  @configure 'Transport', 'key', 'typeKey', 'goodKeys', 'goodTypeKeys', 'isPrimary',
    'consumption', 'reliability', 'carrying', 'travelSpeed', 'basicPrice'

  name: ->
    I18n.t("game_data.transport.#{ @key }")

  goodNames: ->


module.exports = Transport