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

    @currentProductionumber = null

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('factories/start')
    )

  bindEventListeners: ->
    super

    request.bind('factory_started', @.onFactoryStarted)

    @el.on('click', '.production:not(.selected)', @.onProductionClick)
    @el.on('click', '.controls:not(.disabled) .run:not(.disabled)', @.onRunClick)

  unbindEventListeners: ->
    super

    request.unbind('factory_started', @.onFactoryStarted)

    @el.off('click', '.production:not(.selected)', @.onProductionClick)
    @el.off('click', '.controls:not(.disabled) .run:not(.disabled)', @.onRunClick)

  onProductionClick: (e)=>
    @el.find('.production.selected').removeClass('selected')

    optionEl = $(e.currentTarget)

    optionEl.addClass('selected')

    @currentProductionumber = optionEl.data('production-number')

    @el.find('.run').removeClass('disabled')

  onRunClick: =>
    @el.find('.controls').addClass('disabled')

    request.send('start_factory', factory_id: @factory.id, production_number: @currentProductionumber)

  onFactoryStarted: (response)=>
    if response.is_error
      @.render()

      @.displayResult(
        @el.find('.run')
        response
        position: "right bottom"
      )

    else
      @.close()

module.exports = StartFactoryModal