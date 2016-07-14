Modal = require("../modal")
request = require('../../lib').request
ctx = require('../../context')
PropertyType = require('../../game_data').PropertyType

class PropertyRentOutModal extends Modal
  className: 'property_rent_out modal'

  show: (@propertyId)->
    @playerState = ctx.get('playerState')

    super

    @.defineData()

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('properties/rent_out')
    )

  bindEventListeners: ->
    super

  unbindEventListeners: ->
    super

  defineData: ->
    @property = @playerState.findProperty(@propertyId)
    @propertyType = PropertyType.find(@property.typeId)


module.exports = PropertyRentOutModal