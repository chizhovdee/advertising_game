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

    @.addOperation('add', newId, @.adToJSON(newResource))

  adToJSON: (ad)->
    resource = _.clone(ad)
    resource.lifeTimeLeft = resource.completeAt - Date.now()

    resource


  toJSON: ->
    state = {}

    for id, resource of @state
      state[id] = @.adToJSON(resource)

    state

module.exports = AdvertisingState