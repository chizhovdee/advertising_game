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

    state = _.cloneDeep(@player[@stateName] || {})
    _.defaultsDeep(state, @defaultState) # если появятся новые свойства, они будут включены сюда по умолчанию

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

  resourceFor: (id)->
    throw new Error('record not found for resource') unless @state[id]?

    {type: @stateName, id: id}

  addOperation: (type, id, data)->
    throw new Error('unknown operation: type' + type) unless type in BaseState.operationTypes

    @changingOperations.push([type, id, data])

  generateId: (excludingdIds)->
    excludingdIds ?= _.keys(@state)

    id = _.random(10000000)
    id = _.random(10000000) while id in excludingdIds
    id

  update: ->
    @player[@stateName] = @state

  selectRecords: (callback)->
    result = []

    for id, record of @state
      result.push record if callback(record)

    result

  findRecord: (id)->
    @state[id]

  addRecord: (newId, newRecord)->
    @state[newId] = newRecord

    @.update()
  
    @.addOperation('add', newId, @.recordToJSON(newRecord))

  updateRecord: (id)->
    @state[id].updatedAt = Date.now()

    @.update()

    @.addOperation('update', id, @.recordToJSON(@state[id]))

  deleteRecord: (id)->
    delete @state[id]

    @.addOperation('delete', id)

    @.update()

  destroyAllRecords: ->
    for id, record of @state
      delete @state[id]

      @.addOperation('delete', id)

    @.update()

  recordToJSON: (record)->
    record = _.clone(record)
    record.loadedAt = Date.now()

    record

  recordsCount: ->
    _.size(@state)

  toJSON: ->
    state = {}

    for id, record of @state
      state[id] = @.recordToJSON(record)

    state

module.exports = BaseState