_ = require('lodash')
BaseState = require('./base')

class FactoriesState extends BaseState
  defaultState: {}
  stateName: "factories"

  findRecordByFactoryTypeId: (factoryTypeId)->
    for id, record of @state
      return record if record.factoryTypeId == factoryTypeId

  createFactory: (factoryTypeId, buildDuration)->
    newId = @.generateId()
    newRecord = {
      id: newId
      factoryTypeId: factoryTypeId
      level: 1
      createdAt: Date.now()
      updatedAt: Date.now()
      builtAt: Date.now() + buildDuration
    }

    @state[newId] = newRecord

    @.update()

    @.addOperation('add', newId, @.recordToJSON(newRecord))

  accelerateBuilding: (id)->
    delete @state[id].builtAt
    delete @state[id].upgradeAt

    @state[id].updatedAt = Date.now()

    @.update()

    @.addOperation('update', id, @.recordToJSON(@state[id]))

  upgrade: (id, duration)->
    delete @state[id].builtAt # удаление лишнего поля

    @state[id].upgradeAt = Date.now() + duration
    # after
    @state[id].level += 1
    @state[id].updatedAt = Date.now()

    @.update()

    @.addOperation('update', id, @.recordToJSON(@state[id]))

  buildingTimeLeftFor: (factory)->
    factory.builtAt - Date.now()

  factoryIsBuilding: (factory)->
    factory.builtAt? && factory.builtAt > Date.now()

  upgradingTimeLeftFor: (factory)->
    factory.upgradeAt - Date.now()

  factoryIsUpgrading: (factory)->
    factory.upgradeAt? && factory.upgradeAt > Date.now()

  recordToJSON: (record)->
    record = super(record)

    if @.factoryIsBuilding(record)
      record.buildingTimeLeft = @.buildingTimeLeftFor(record)

    else if @.factoryIsUpgrading(record)
      record.upgradingTimeLeft = @.upgradingTimeLeftFor(record)

    record

  toJSON: ->
    state = {}

    for id, record of @state
      state[id] = @.recordToJSON(record)

    state

module.exports = FactoriesState