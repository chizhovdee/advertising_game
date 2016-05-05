Base = require("./base")

class Transport extends Base
  @configure 'Transport', 'key', 'typeKey', 'goodKeys', 'goodTypeKeys', 'isPrimary',
    'consumption', 'reliability', 'carrying', 'travelSpeed'

  name: ->
    I18n.t("game_data.transports.#{ @key }")

module.exports = Transport