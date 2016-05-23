class PlayerState extends Spine.Model
  @configure "PlayerState", "oldAttributes", 'staff', 'trucking', 'advertising'

  @include require('./modules/model_changes')

  update: ->
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    super

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

    @.updateAttributes(changes)

module.exports = PlayerState

