Base = require("./base")

class Transport extends Base
  @configure 'Transport', 'key', 'level', 'typeKey', 'goodKeys', 'goodTypeKeys', 'isPrimary',
    'consumption', 'reliability', 'carrying', 'travelSpeed', 'basicPrice', 'subType'

  name: ->
    I18n.t("game_data.transport.#{ @key }")

  goodNames: ->
    str = ""

    if @goodTypeKeys?
      for goodTypeKey in @goodTypeKeys
        str += ", " if str.length > 0
        str += _.toLower(I18n.t("game_data.good_types.#{ goodTypeKey }"))

    if @goodKeys?
      for goodKey in @goodKeys
        str += ", " if str.length > 0
        str += _.toLower(I18n.t("game_data.goods.#{ goodKey }"))

    str

module.exports = Transport