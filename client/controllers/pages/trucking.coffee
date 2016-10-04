Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
ctx = require('../../context')
balance = require('../../lib').balance

VisualTimer = require('../../lib').VisualTimer

class TruckingPage extends Page
  className: "trucking page"

  PER_PAGE = 10

  show: ->
    @playerState = ctx.get('playerState')

    super

    @timers = {}

    @.defineData()

    @.render()

  hide: ->
    for id, timer of @timers
      timer.stop()

    super

  render: ->
    @html(@.renderTemplate("trucking/index"))

    @.setupTimers()

  renderList: ->
    @el.find('.list').html(@.renderTemplate("trucking/list"))

    @.setupTimers()

  setupTimers: ->
    for trucking in @paginatedList
      unless trucking.isCompleted()
        @timers[trucking.id] ?= new VisualTimer(null, => @.renderList())
        @timers[trucking.id].setElement($("#trucking_#{ trucking.id } .timer .value"))
        @timers[trucking.id].start(trucking.actualCompleteIn())

  bindEventListeners: ->
    super

    @playerState.bind('update', @.onStateUpdated)

    request.bind('trucking_collected', @.onTruckingCollected)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.collect:not(.disabled)', @.onCollectClick)
    @el.on('click', '.accelerate:not(.disabled)', @.onAccelerateClick)
    @el.on('click', '.start_accelerate:not(.disabled)', @.onStartAccelerateClick)

  unbindEventListeners: ->
    super

    @playerState.unbind('update', @.onStateUpdated)

    request.unbind('trucking_collected', @.onTruckingCollected)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.collect:not(.disabled)', @.onCollectClick)
    @el.off('click', '.accelerate:not(.disabled)', @.onAccelerateClick)
    @el.off('click', '.start_accelerate:not(.disabled)', @.onStartAccelerateClick)

  defineData: ->
    @list = _.sortBy(@playerState.truckingRecords(), (t)-> t.completeIn)

    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

  # events
  onListPaginateClick: (e)=>
    @paginatedList = @listPagination.paginate(@list,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderList()

  onSwitchPageClick: (e)=>
    @paginatedList = @listPagination.paginate(@list,
      start_count: ($(e.currentTarget).data('page') - 1) * @listPagination.per_page
    )

    @.renderList()

  onCollectClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')

    request.send('collect_trucking', trucking_id: button.data('trucking-id'))

  onTruckingCollected: (response)=>
    @.displayResult(null, response)

  onAccelerateClick: (e)=>
    button = $(e.currentTarget)
    trucking = @playerState.findTruckingRecord(button.data('trucking-id'))

    @.displayPopup(button
      @.renderTemplate("trucking/accelerate_popup", trucking: trucking)
      position: 'left bottom'
    )

  onStartAccelerateClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')

    $("#trucking_#{ button.data('trucking-id') } button.accelerate").addClass('disabled')

    request.send("accelerate_trucking", trucking_id: button.data('trucking-id'))

  onStateUpdated: (playerState)=>
    console.log changes = playerState.changes()

    return unless changes.trucking?

    @.defineData()

    @.renderList()

  acceleratePriceRequirement: (trucking)->
    price = balance.acceleratePrice(trucking.actualCompleteIn())

    {vip_money: [@.formatNumber(price), @player.vip_money >= price]}


module.exports = TruckingPage
