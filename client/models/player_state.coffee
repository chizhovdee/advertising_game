# для того чтобы новое поле стейта заработало на клиенте,
# нужно добавить атрибут здесь и вписать в массив Player.stateFields на бэкенде

settings = require('../settings')
gameData = require('../game_data')

PropertyRecord = require('./property_record')
Transport = gameData.Transport

class PlayerState extends Spine.Model
  @configure "PlayerState", "oldAttributes",
    'trucking', 'truckingUpdatedAt', 'routes', 'routesUpdatedAt',
    'advertising', 'advertisingUpdatedAt', 'properties', 'propertiesUpdatedAt',
    'transport', 'transportUpdatedAt'

  @include require('./modules/model_changes')

  # resources list from states
  _properties: null

  create: ->
    for attribute, value of @.attributes()
      @.setStateUpdatedAt(attribute)

    super

  update: ->
    console.log _.cloneDeep(@constructor.irecords[@id].attributes().properties)
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    # reset
    @_properties = null

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

  propertyRecords: ->
    @_propertyRecords ?= (
      for id, data of @properties
        new PropertyRecord(_.assignIn({id: _.toInteger(id)}, data))
    )

  findPropertyRecord: (id)->
    _.find(@.propertyRecords(), id: id)

  transportCountByTransportTypeKey: (transportTypeKey)->
    count = 0

    for id, resource of @transport
      (count += 1 if Transport.find(resource.typeId)?.typeKey == transportTypeKey)

    count

  advertisingCount: ->
    _.keys(@advertising).length


module.exports = PlayerState

