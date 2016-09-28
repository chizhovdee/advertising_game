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

    @.addRecord(newId, newRecord)

  accelerateFactory: (id)->
    delete @state[id].builtAt
    delete @state[id].upgradeAt

    @state[id].productionFinishAt = Date.now() if @state[id].productionFinishAt?

    @.updateRecord(id)

  upgradeFactory: (id, duration)->
    delete @state[id].builtAt # удаление лишнего поля

    @state[id].upgradeAt = Date.now() + duration
    # after
    @state[id].level += 1

    @.updateRecord(id)

  startFactory: (id, productionNumber, duration)->
    @state[id].productionFinishAt = Date.now() + duration
    @state[id].productionNumber = productionNumber

    @.updateRecord(id)

  collectFactory: (id)->
    delete @state[id].productionFinishAt
    delete @state[id].productionNumber

    @.updateRecord(id)

  buildingTimeLeftFor: (factory)->
    factory.builtAt - Date.now()

  factoryIsBuilding: (factory)->
    factory.builtAt? && factory.builtAt > Date.now()

  upgradingTimeLeftFor: (factory)->
    factory.upgradeAt - Date.now()

  factoryIsUpgrading: (factory)->
    factory.upgradeAt? && factory.upgradeAt > Date.now()

  productionTimeLeftFor: (factory)->
    factory.productionFinishAt - Date.now()

  factoryInProduction: (factory)->
    factory.productionFinishAt? && factory.productionFinishAt > Date.now()

  canCollectFactory: (factory)->
    factory.productionFinishAt? && factory.productionFinishAt < Date.now()

  recordToJSON: (record)->
    record = super(record)

    if @.factoryIsBuilding(record)
      record.buildingTimeLeft = @.buildingTimeLeftFor(record)

    else if @.factoryIsUpgrading(record)
      record.upgradingTimeLeft = @.upgradingTimeLeftFor(record)

    else if record.productionFinishAt?
      record.productionTimeLeft = @.productionTimeLeftFor(record)

    record


module.exports = FactoriesState