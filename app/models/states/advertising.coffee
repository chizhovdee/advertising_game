_ = require('lodash')
BaseState = require('./base')

class AdvertisingState extends BaseState
  defaultState: {}
  stateName: "advertising"

  generateId: ->
    super(_.keys(@state))

  create: (type, status, period)->
    newId = @.generateId()
    newResource = {
      typeId: type.id
      status: status
      completeAt: Date.now() + _(period).hours()
    }

    @state[newId] = newResource

    @.update()

    @.addOperation('add', newId, newResource)

  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = _.clone(resource)
      state[id].lifeTimeLeft = resource.completeAt - Date.now()

    state

module.exports = AdvertisingState