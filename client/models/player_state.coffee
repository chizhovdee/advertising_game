# для того чтобы новое поле стейта заработало на клиенте,
# нужно добавить атрибут здесь и вписать в массив Player.stateFields на бэкенде

settings = require('../settings')
gameData = require('../game_data')

Property = gameData.Property

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

  getProperties: ->
    @_properties ?= (
      for id, data of @properties
        new Property(_.assignIn({id: _.toInteger(id)}, data))
    )

  findProperty: (id)->
    _.find(@.getProperties(), id: id)

module.exports = PlayerState

