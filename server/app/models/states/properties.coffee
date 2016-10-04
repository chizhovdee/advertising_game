_ = require('lodash')
BaseState = require('./base')

class PropertiesState extends BaseState
  defaultState: {}
  stateName: "properties"

  findRecordByPropertyTypeId: (propertyTypeId)->
    for id, record of @state
      return record if record.propertyTypeId == propertyTypeId

  createProperty: (propertyTypeId, buildDuration)->
    newId = @.generateId()
    newRecord = {
      id: newId
      propertyTypeId: propertyTypeId
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

  buildingTimeLeftFor: (property)->
    property.builtAt - Date.now()

  propertyIsBuilding: (property)->
    property.builtAt? && property.builtAt > Date.now()

  upgradingTimeLeftFor: (property)->
    property.upgradeAt - Date.now()

  propertyIsUpgrading: (property)->
    property.upgradeAt? && property.upgradeAt > Date.now()

  recordToJSON: (record)->
    record = super(record)

    if @.propertyIsBuilding(record)
      record.buildingTimeLeft = @.buildingTimeLeftFor(record)

    else if @.propertyIsUpgrading(record)
      record.upgradingTimeLeft = @.upgradingTimeLeftFor(record)

    record


module.exports = PropertiesState