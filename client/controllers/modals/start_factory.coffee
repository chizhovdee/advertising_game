Modal = require("../modal")
request = require("../../lib/request")
balance = require('../../lib/balance')
ctx = require('../../context')
FactoryType = require('../../game_data').FactoryType

class StartFactoryModal extends Modal
  className: 'start_factory modal'

  show: (factoryId)->
    super

    @playerState = ctx.get('playerState')

    @factory = _.find(@playerState.factoryRecords(), (p)-> p.id == factoryId)
    @factoryType = FactoryType.find(@factory.factoryTypeId)

    @currentDuration = null

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('factories/start')
    )

  bindEventListeners: ->
    super

    @el.on('click', '.option:not(.selected)', @.onOptionClick)
    @el.on('click', '.controls:not(.disabled) .make:not(.disabled)', @.onMakeClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.option:not(.selected)', @.onOptionClick)
    @el.off('click', '.controls:not(.disabled) .make:not(.disabled)', @.onMakeClick)

  onOptionClick: (e)=>
    @el.find('.option.selected').removeClass('selected')

    optionEl = $(e.currentTarget)

    optionEl.addClass('selected')

    @currentDurationNumber = optionEl.data('duration-number')

    @el.find('.make').removeClass('disabled')

  onMakeClick: =>
    @el.find('.controls').addClass('disabled')

    request.send('start_factory', factory_id: @factory.id, duration_number: @currentDurationNumber)

module.exports = StartFactoryModal