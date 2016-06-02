class PlayerState extends Spine.Model
  @configure "PlayerState", "oldAttributes",
    'staff', 'staffUpdatedAt', 'trucking', 'truckingUpdatedAt',
    'advertising', 'advertisingUpdatedAt', 'properties', 'propertiesUpdatedAt'

  @include require('./modules/model_changes')

  STATES = [
    'staff', 'trucking', 'advertising', 'properties'
  ]

  create: ->
    for attribute, value of @.attributes()
      @.setStateUpdatedAt(attribute)

    super

  update: ->
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    super

  setStateUpdatedAt: (attribute)->
    return unless attribute in STATES

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

