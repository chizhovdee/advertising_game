Modal = require("../modal")
request = require('../../lib').request
ctx = require('../../context')

class PropertyRentOutModal extends Modal
  className: 'property_rent_out modal'

  show: (@propertyId)->
    console.log @propertyId
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

module.exports = PropertyRentOutModal