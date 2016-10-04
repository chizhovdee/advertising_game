Base = require("./base")
ctx = require("../context")

class TownLevel extends Base
  @configure 'TownLevel', 'key', 'number', 'materials'

  getMaterial: (materialKey)->
    @materials[materialKey]

  @findByNumber: (number)->
    @.detect((l)-> l.number == number)

  isContainMaterial: (materialKey)->
    @materials[materialKey]?

  bonusBasicMoney: ->
    settings = ctx.get('settings')

    settings.townLevel.bonusBasicMoney +
    settings.townLevel.bonusBasicMoney * (@number - 1) *
    settings.townLevel.bonusFactor

module.exports = TownLevel