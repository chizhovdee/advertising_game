Base = require("./base")

class Advertising extends Base
  @configure 'Advertising', 'key', 'level', 'basicPrice'

  name: ->
    I18n.t("game_data.advertising.#{@key}")

module.exports = Advertising