Modal = require("../modal")
request = require('../../lib').request
ctx = require('../../context')

class PropertyRentOutModal extends Modal
  className: 'property_rent_out modal'

  show: (@propertyId)->
    @playerState = ctx.get('playerState')
    console.log @playerState.findProperty(@propertyId)

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

module.exports = PropertyRentOutModal