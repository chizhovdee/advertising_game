_ = require('lodash')
BaseState = require('./base')

class AdvertisingState extends BaseState
  defaultState: {}
  stateName: "advertising"

  generateId: ->
    super(_.keys(@state))

  create: (type, status, period)->
    result = @state[@.generateId()] = {
      typeId: type.id
      status: status
      completeAt: Date.now() + _(period).hours()
    }

    @.update()

    result

module.exports = AdvertisingState