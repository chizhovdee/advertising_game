# для того чтобы новое поле стейта заработало на клиенте,
# нужно добавить атрибут здесь и вписать в массив Player.stateFields на бэкенде

settings = require('../settings')
gameData = require('../game_data')

# state records
PropertyRecord = require('./property_record')
AdvertisingRecord = require('./advertising_record')

# game data
AdvertisingType = gameData.AdvertisingType
Transport = gameData.Transport

class PlayerState extends Spine.Model
  @configure "PlayerState", "oldAttributes",
    'trucking', 'truckingUpdatedAt', 'routes', 'routesUpdatedAt',
    'advertising', 'advertisingUpdatedAt', 'properties', 'propertiesUpdatedAt',
    'transport', 'transportUpdatedAt'

  @include require('./modules/model_changes')

  # records list from states
  _propertyRecords: null
  _advertisingRecords: null

  create: ->
    for attribute, value of @.attributes()
      @.setStateUpdatedAt(attribute)

    super

  update: ->
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    # reset
    @_propertyRecords = null
    @_advertisingRecords = null

    super

  setStateUpdatedAt: (attribute)->
    return unless attribute in settings.player.stateFields

    @["#{ attribute }UpdatedAt"] = Date.now()

  applyChangingOperations: (operations)->
    for key, data of operations
      state = _.cloneDeep(@[key])

      for [type, id, resource] in data
        switch type
          when 'add', 'update'
            state[id] = resource
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

  # transport
  transportCountByTransportTypeKey: (transportTypeKey)->
    count = 0

    for id, resource of @transport
      (count += 1 if Transport.find(resource.typeId)?.typeKey == transportTypeKey)

    count

  # advertising
  advertisingCount: ->
    _.size(@advertising)

  advertisingRecords: ->
    @_advertisingRecords ?= (
      for id, data of @advertising
        new AdvertisingRecord(_.assignIn({
          type: AdvertisingType.find(data.typeId)
        }, data))
    )

  findAdvertisingRecord: (id)->
    _.find(@.advertisingRecords(), id: id)

module.exports = PlayerState

