class BaseResource
  constructor: (attributes)->
    for attribute, value of attributes
      @[attribute] = value

  timeDiff: ->
    Date.now() - @loadedAt

module.exports = BaseResource
