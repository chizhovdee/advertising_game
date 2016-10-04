_ = require("lodash")
Base = require("./base")

class PlaceType extends Base
  @configure publicForClient: true

  position: null

  constructor: ->
    super

    @position = null

  validateOnDefine: ->
    throw new Error('undefined @position') unless @position?

  toJSON: ->
    _.assign(
      position: @position
      ,
      super
    )


module.exports = PlaceType