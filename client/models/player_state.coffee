# для того чтобы новое поле стейта заработало на клиенте,
# нужно добавить атрибут здесь и вписать в массив Player.stateFields на бэкенде

settings = require('../settings')

class PlayerState extends Spine.Model
  @configure "PlayerState", "oldAttributes",
    'trucking', 'truckingUpdatedAt', 'routes', 'routesUpdatedAt',
    'advertising', 'advertisingUpdatedAt', 'properties', 'propertiesUpdatedAt',
    'transport', 'transportUpdatedAt'

  @include require('./modules/model_changes')

  create: ->
    for attribute, value of @.attributes()
      @.setStateUpdatedAt(attribute)

    super

  update: ->
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    super

  setStateUpdatedAt: (attribute)->
    return unless attribute in settings.player.stateFields

    @["#{ attribute }UpdatedAt"] = Date.now()

  applyChangingOperations: (operations)->
    changes = {}

    for key, data of operations
      state = @[key]

      for [type, id, resource] in data
        switch type
          when 'add', 'update'
            state[id] = resource
          when 'delete'
            delete state[id]

      changes[key] = state

      @.setStateUpdatedAt(key)

    @.updateAttributes(changes) unless _.isEmpty(changes)

module.exports = PlayerState

