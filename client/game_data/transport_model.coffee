Base = require("./base")

class TransportModel extends Base
  @configure 'TransportModel', 'key', 'level', 'transportGroupKey', 'materials', 'isPrimary',
    'reliability', 'carrying', 'travelSpeed', 'basicPrice'

  name: ->
    I18n.t("game_data.transport_model.#{ @key }")

module.exports = TransportModel