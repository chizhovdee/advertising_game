module.exports =
  setOldAttributes: (attributes)->
    @oldAttributes = _.omit(_.cloneDeep(attributes), 'oldAttributes')

  changes: ->
    changes = {}

    for attribute, value of @.attributes()
      continue if attribute == "oldAttributes"

      unless _.isEqual(value, @oldAttributes[attribute])
        changes[attribute] = [@oldAttributes[attribute], value]

    changes