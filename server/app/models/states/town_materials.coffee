_ = require('lodash')
BaseState = require('./base')
MaterialType = require('../../game_data').MaterialType

class TownMaterialsState extends BaseState
  defaultState: {}

  stateName: "town_materials"

  addMaterial: (materialTypeKey, value)->
    if @state[materialTypeKey]?
      if @.leftTimeToLimitForRecord(@state[materialTypeKey]) > 0
        @state[materialTypeKey].value += value
      else
        @state[materialTypeKey].value = value

      @.updateRecord(materialTypeKey)

    else
      newRecord = {
        updatedAt: Date.now()
        value: value
      }

      @.addRecord(materialTypeKey, newRecord)

    @.checkMaterials()

  checkMaterials: ->
    beginningOfDay =  _(new Date()).beginningOfDay()

    for type in MaterialType.all()
      continue unless @state[type.key]

      if beginningOfDay > new Date(@state[type.key].updatedAt)
        @.deleteRecord(type.key)

  leftTimeToLimitForRecord: (record)->
    beginningOfDayByUpdatedAt = _(new Date(record.updatedAt)).beginningOfDay()

    if beginningOfDayByUpdatedAt < _(new Date()).beginningOfDay()
      0
    else
      (beginningOfDayByUpdatedAt.valuOf() + _(1).days()) - Date.now()

  recordToJSON: (record)->
    record = super(record)

    record.leftTimeToLimit = @.leftTimeToLimitForRecord(record)

    record


module.exports = TownMaterialsState