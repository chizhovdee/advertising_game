class Base extends Spine.Model
  @recordsByKey: {}

  @populate: (data)->
    @refresh(
      for values in data.values
        obj = {}

        for value, index in values
          obj[data.keys[index]] = value

        obj
    )

  @configure: ->
    @recordsByKey = {}

    super

  @addRecord: ->
    record = super

    @recordsByKey[record.key] = record.id

    record

  @deleteAll: ->
    super

    @recordsByKey = {}

  @find: (idOrKey, notFound = @notFound)->
    id = if _.isInteger(idOrKey)
      idOrKey
    else if (intId = _.toInteger(idOrKey)) && intId > 0
      intId
    else
      @recordsByKey[idOrKey]

    @irecords[id]?.clone() or notFound?.call(this, id)

  remove: ->
    super

    delete @constructor.recordsByKey[@key] if options.clear

  getReward: (trigger, multiplier = 1)->
    return unless @reward?[trigger]?

    reward = {}

    for key, value of @reward[trigger]
      if _.isPlainObject(value) # materials...
        for type, amount of value
          reward[key] ?= {}
          reward[key][type] = amount * multiplier
      else
        reward[key] = value * multiplier

    reward

  getRequirement: (trigger, player, playerState, resource, multiplier = 1)->
    return unless @requirement?[trigger]?

    requirement = {}

    for key, value of @requirement[trigger]
      if key == 'materials'
        throw new Error('undefined resource') unless resource?

        for type, amount of value
          source = playerState.getMaterialFor(resource, type)

          requirement[key] ?= {}
          requirement[key][type] = [amount * multiplier, source >= amount * multiplier]
      else
        requirement[key] = [value * multiplier, player[key] >= value * multiplier]

    requirement

module.exports = Base