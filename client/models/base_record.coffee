# используется для структурирования одтельных записей в стейте
time = require('../utils').time

class BaseRecord
  constructor: (attributes)->
    for attribute, value of attributes
      @[attribute] = value

  loadedTimeDiff: ->
    time.serverTime() - @loadedAt

module.exports = BaseRecord
