Base = require("./base")

class TransportModel extends Base
  @configure 'TransportModel', 'key', 'level', 'transportGroupKey', 'goodKeys', 'isPrimary',
    'consumption', 'reliability', 'carrying', 'travelSpeed', 'basicPrice'

  name: ->
    I18n.t("game_data.transport_model.#{ @key }")

  goodNames: ->
    str = ""

    if @goodKeys?
      for goodKey in @goodKeys
        str += ", " if str.length > 0
        str += _.toLower(I18n.t("game_data.goods.#{ goodKey }"))

    str

module.exports = TransportModel