Base = require("./base")

class PropertyType extends Base
  @configure 'PropertyType', 'key', 'basicPrice', 'buildLevel', 'buildDuration'

  name: ->
    I18n.t("game_data.property_types.#{@key}")

module.exports = PropertyType