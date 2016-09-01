_ = require('lodash')
BaseState = require('./base')
MaterialType = require('../../game_data').MaterialType

class MaterialsState extends BaseState
  defaultState: null
  stateName: "materials"

  constructor: ->
    @defaultState = {}
    @defaultState[type.key] = 0 for type in MaterialType.all()
    
    super

  give: (materialTypeKey, value)->
    @state[materialTypeKey] += value

    @.update()

    @.addOperation('update', materialTypeKey, @state[materialTypeKey])

  take: (materialTypeKey, value)->
    @state[materialTypeKey] -= value
    @state[materialTypeKey] = 0 if @state[materialTypeKey] < 0

    @.update()

    @.addOperation('update', materialTypeKey, @state[materialTypeKey])

  toJSON: ->
    @state

module.exports = MaterialsState