Base = require("./base")

class Route extends Base
  @configure 'Route', 'key', 'status', 'goodKey',
    'reputation', 'requirement', 'reward', 'distance', 'weight'

  name: ->
    I18n.t("game_data.routes.#{ @key }")

  goodName: ->
    I18n.t("game_data.goods.#{ @goodKey }")

module.exports = Route