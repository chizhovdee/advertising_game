Base = require("./base")

class TownLevel extends Base
  @configure 'TownLevel', 'key', 'number', 'materials'

  isContainMaterial: (materialKey)->
    materialKey in @materials

module.exports = TownLevel