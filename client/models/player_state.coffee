# для того чтобы новое поле стейта заработало на клиенте,
# нужно добавить атрибут здесь и вписать в массив Player.stateFields на бэкенде

ctx = require('../context')

# state records
PropertyRecord = require('./property_record')
FactoryRecord = require('./factory_record')
AdvertisingRecord = require('./advertising_record')

# game data
gameData = require('../game_data')
AdvertisingType = gameData.AdvertisingType


class PlayerState extends Spine.Model
  @configure "PlayerState", "oldAttributes",
    'trucking', 'truckingUpdatedAt', 'advertising', 'advertisingUpdatedAt',
    'routes', 'routesUpdatedAt', 'transport', 'transportUpdatedAt',
    'properties', 'propertiesUpdatedAt', 'factories', 'factoriesUpdatedAt',
    'materials', 'materialsUpdateAt'

  @include require('./modules/model_changes')

  # records list from states
  _propertyRecords: null
  _advertisingRecords: null
  _factoryRecords: null

  create: ->
    for attribute, value of @.attributes()
      @.setStateUpdatedAt(attribute)

    super

  update: ->
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    # reset
    @_propertyRecords = null
    @_advertisingRecords = null
    @_factoryRecords = null

    super

  setStateUpdatedAt: (attribute)->
    return unless attribute in ctx.get('settings').player.stateFields

    @["#{ attribute }UpdatedAt"] = Date.now()

  applyChangingOperations: (operations)->
    @lastChangingOperations = {}

    for key, data of operations
      state = _.cloneDeep(@[key])

      for [type, idOrResource, value] in data
        @lastChangingOperations[key] ?= {}
        @lastChangingOperations[key][type] ?= []
        @lastChangingOperations[key][type].push(idOrResource)

        if key == 'materials'
          resource = idOrResource

          state[resource.type][resource.id] ?= {}
          state[resource.type][resource.id][resource.materialTypeKey] ?= 0
          state[resource.type][resource.id][resource.materialTypeKey] = value

        else
          id = idOrResource

          switch type
            when 'add', 'update'
              state[id] = value
            when 'delete'
              delete state[id]

      @[key] = state

      @.setStateUpdatedAt(key)

    @.save() unless _.isEmpty(operations)

  # properties
  propertyRecords: ->
    @_propertyRecords ?= (
      for id, data of @properties
        new PropertyRecord(data)
    )

  findPropertyRecord: (id)->
    _.find(@.propertyRecords(), id: id)

  # factories
  factoryRecords: ->
    @_factoryRecords ?= (
      for id, data of @factories
        new FactoryRecord(data)
    )

  findFactoryRecord: (id)->
    _.find(@.factoryRecords(), id: id)

  # transport
  transportCount: ->
    _.size(@transport)

  # advertising
  advertisingCount: ->
    _.size(@advertising)

  advertisingRecords: ->
    @_advertisingRecords ?= (
      for id, data of @advertising
        new AdvertisingRecord(_.assignIn({
          type: AdvertisingType.find(data.advertisingTypeId)
        }, data))
    )

  findAdvertisingRecord: (id)->
    _.find(@.advertisingRecords(), id: id)

  getMaterialFor: (resource, materialKey)->
    throw new Error('resource is undefined') unless resource?

    @materials[resource.type][resource.id]?[materialKey] || 0

module.exports = PlayerState

