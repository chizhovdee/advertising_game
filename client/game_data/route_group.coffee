Base = require("./base")

class RouteGroup extends Base
  @configure 'RouteGroup', 'key', 'level'

  name: ->
    I18n.t("game_data.route_groups.#{ @key }")

module.exports = RouteGroup