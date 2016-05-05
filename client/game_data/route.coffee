Base = require("./base")

class Route extends Base
  @configure 'Route', 'key', 'typeKey', 'goodKey', 'goodTypeKey',
    'requirement', 'reward', 'distance'

  name: ->
    I18n.t("game_data.routes.#{ @key }")

  goodName: ->
    if @goodKey?
      I18n.t("game_data.goods.#{ @goodKey }")
    else if @goodTypeKey?
      I18n.t("game_data.good_types.#{ @goodTypeKey }")
    else
      "?"


module.exports = Route