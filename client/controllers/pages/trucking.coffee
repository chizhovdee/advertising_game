Page = require("../page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
ctx = require('../../context')

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

  unbindEventListeners: ->
    super

    @playerState.unbind('update', @.onStateUpdated)

    request.unbind('trucking_collected', @.onTruckingCollected)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.collect:not(.disabled)', @.onCollectClick)

  defineData: ->
    console.log @list = _.sortBy(@playerState.truckingRecords(), (t)-> t.completeIn)

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
    console.log response

    @.displayResult(null, response)

  onStateUpdated: =>
    console.log changes = @playerState.changes()

    return unless changes.trucking?

    @.defineData()
    
    @.renderList()


module.exports = TruckingPage
