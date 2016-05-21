Base = require("./base")

class AdvertisingType extends Base
  @configure 'AdvertisingType', 'key', 'timeGeneration', 'basicPrice'

  name: ->
    I18n.t("game_data.advertising.#{@key}")

module.exports = AdvertisingType