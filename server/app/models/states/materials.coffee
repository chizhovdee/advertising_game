_ = require('lodash')
BaseState = require('./base')

class MaterialsState extends BaseState
  defaultState: {
    factories: {}
    places: {}
  }

  stateName: "materials"

  getFor: (resource, materialTypeKey)  ->
    @state[resource.type][resource.id]?[materialTypeKey] || 0

  give: (resource, materialTypeKey, value)->
    @.check(resource, materialTypeKey)

    @state[resource.type][resource.id][materialTypeKey] += value

    @.update()

    @.addOperation(
      'update'
      _.assignIn({}, resource, materialTypeKey: materialTypeKey)
      @state[resource.type][resource.id][materialTypeKey]
    )

  take: (resource, materialTypeKey, value)->
    @.check(resource, materialTypeKey)

    @state[resource.type][resource.id][materialTypeKey] -= value

    if @state[resource.type][resource.id][materialTypeKey] < 0
      @state[resource.type][resource.id][materialTypeKey] = 0

    @.update()

    @.addOperation(
      'update'
      _.assignIn({}, resource, materialTypeKey: materialTypeKey)
      @state[resource.type][resource.id][materialTypeKey]
    )

  check: (resource, materialTypeKey)->
    throw new Error('resource is undefined') unless resource?

    @state[resource.type][resource.id] ?= {}

    @state[resource.type][resource.id][materialTypeKey] ?= 0

  toJSON: ->
    @state

module.exports = MaterialsState