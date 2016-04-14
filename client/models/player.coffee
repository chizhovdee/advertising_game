class Player extends Spine.Model
  @configure "Player", "oldAttributes", "level", "experience", "basic_money", "vip_money",
    'experience_to_next_level', 'level_progress_percentage', 'reputation', 'fuel'

  update: ->
    @.setOldAttributes(@constructor.irecords[@id].attributes())

    super

  setOldAttributes: (attributes)->
    @oldAttributes = _.omit(_.cloneDeep(attributes), 'oldAttributes')

  changes: ->
    changes = {}

    for attribute, value of @.attributes()
      continue if attribute == "oldAttributes"

      if _.isObject(value)
        unless _.isEqual(value, @oldAttributes[attribute])
          changes[attribute] = [@oldAttributes[attribute], value]

      else if value != @oldAttributes[attribute]
        changes[attribute] = [@oldAttributes[attribute], value]

    changes

module.exports = Player

