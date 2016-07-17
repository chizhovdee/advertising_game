module.exports =
  setOldAttributes: (attributes)->
    @oldAttributes = _.omit(_.cloneDeep(attributes), 'oldAttributes')

  changes: ->
    changes = {}

    for attribute, value of @.attributes()
      continue if attribute == "oldAttributes"

      #console.log attribute, value, @oldAttributes[attribute]

      unless _.isEqual(value, @oldAttributes[attribute])
        changes[attribute] = [@oldAttributes[attribute], value]

    changes