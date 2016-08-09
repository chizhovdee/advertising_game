# используется для структурирования одтельных записей в стейте

class BaseRecord
  constructor: (attributes)->
    for attribute, value of attributes
      @[attribute] = value

  loadedTimeDiff: ->
    Date.now() - @loadedAt

module.exports = BaseRecord
