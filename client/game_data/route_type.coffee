Base = require("./base")

class RouteType extends Base
  @configure 'RouteType', 'key', 'routeGroupKey', 'materialKey', 'level', 'reward', 'distance', 'weight'

  name: ->
    I18n.t("game_data.route_types.#{ @key }")

module.exports = RouteType