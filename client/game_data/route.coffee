Base = require("./base")

class Route extends Base
  @configure 'Route', 'key', 'typeKey', 'goodKey', 'goodTypeKey',
    'requirement', 'reward', 'distance'

  name: ->
    I18n.t("game_data.routes.#{ @key }")

module.exports = Route