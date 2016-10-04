_ = require('lodash')
BaseState = require('./base')
MaterialType = require('../../game_data').MaterialType

class TownMaterialsState extends BaseState
  defaultState: {}

  stateName: "town_materials"

  addMaterial: (materialTypeKey, value)->
    if @state[materialTypeKey]?
      if @.timeLeftToLimitForRecord(@state[materialTypeKey]) > 0
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

  destroyExpiredMaterials: ->
    beginningOfDay =  _.beginningOfDay(new Date())

    for type in MaterialType.all()
      continue unless @state[type.key]

      if beginningOfDay > new Date(@state[type.key].updatedAt)
        @.deleteRecord(type.key)

  timeLeftToLimitForRecord: (record)->
    beginningOfDayByUpdatedAt = _.beginningOfDay(new Date(record.updatedAt))

    if beginningOfDayByUpdatedAt < _.beginningOfDay(new Date())
      0
    else
      (beginningOfDayByUpdatedAt.valueOf() + _.days(1)) - Date.now()

  recordToJSON: (record)->
    record = super(record)

    record.timeLeftToLimit = @.timeLeftToLimitForRecord(record)

    record


module.exports = TownMaterialsState