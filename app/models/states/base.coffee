_ = require('lodash')

class BaseState
  @operationTypes: ['add', 'update', 'delete']

  defaultState: null
  stateName: null # должен совпадать с полем в бд таблице
  changingOperations: null # хранение операций по изменению стейта для передачи на клиент

  constructor: (player)->
    Object.defineProperty(@, 'player', value: player)

    throw new Error("player undefined") unless @player?
    throw new Error("stateName is undefined") unless @stateName?
    throw new Error("defaultState is undefined") unless @defaultState?

    state = (
      if @player[@stateName]
        _.cloneDeep(@player[@stateName])
      else
        _.defaultsDeep({}, @defaultState)
    )

    Object.defineProperty(@, 'state',
      value: state
      writable: false
      enumerable: true
    )

    Object.defineProperty(@, 'changingOperations',
      value: []
      writable: false
      enumerable: true
    )

  addOperation: (type, id, data)->
    throw new Error('unknown operation: type' + type) unless type in BaseState.operationTypes

    @changingOperations.push([type, id, data])

  generateId: (excludingdIds)->
    id = _.random(10000000)
    id = _.random(10000000) while id in excludingdIds
    id

  update: ->
    @player[@stateName] = @state

  extendResource: (resource)->
    _resource = _.clone(resource)
    _resource.loadedAt = Date.now()

    _resource

module.exports = BaseState