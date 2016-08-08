Page = require("../page")
modals = require('../modals')
request = require("../../lib/request")
Pagination = require("../../lib").Pagination
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')
AdvertisingType = require('../../game_data').AdvertisingType

class AdvertisingPage extends Page
  className: 'advertising page'

  PER_PAGE = 3

  show: ->
    @playerState = ctx.get('playerState')

    super

    @expireTimers = {}
    @nextRouteTmers = {}

    @.defineData()

    @.render()

  hide: ->
    for id, timer of @expireTimers
      timer.stop()

    for id, timer of @nextRouteTmers
      timer.stop()

    super

  render: ->
    @html(@.renderTemplate("advertising/index"))

    @.setupTimers()

  renderList: ->
    @el.find('.list').html(@.renderTemplate("advertising/list"))

    @.setupTimers()

  setupTimers: ->
    for record in @paginatedList
      unless record.isExpired()
        @expireTimers[record.id] ?= new VisualTimer()
        @expireTimers[record.id].setElement($("#ad_#{ record.id } .life_timer .value"))
        @expireTimers[record.id].start(record.actualExpireTimeLeft())

      unless record.canOpenRoute()
        @nextRouteTmers[record.id] ?= new VisualTimer()
        @nextRouteTmers[record.id].setElement($("#ad_#{ record.id } .next_route_timer .value"))
        @nextRouteTmers[record.id].start(record.actualNextRouteTimeLeft())

  bindEventListeners: ->
    super

    request.bind('route_opened', @.onRouteOpened)
    request.bind('advertising_created', @.onCreated)
    request.bind('advertising_deleted', @.onDeleted)

    @el.on('click', '.new', @.onNewClick)
    @el.on('click', '.open_route', @.onOpenRouteClick)
    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', '.delete:not(.disabled)', @.onDeleteClick)
    @el.on('click', '.start_delete:not(.disabled)', @.onStartDeleteClick)

    @playerState.bind('update', @.onStateUpdated)

  unbindEventListeners: ->
    super

    request.unbind('route_opened', @.onRouteOpened)
    request.unbind('advertising_created', @.onCreated)
    request.unbind('advertising_deleted', @.onDeleted)

    @el.off('click', '.new', @.onNewClick)
    @el.off('click', '.open_route', @.onOpenRouteClick)
    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', '.delete:not(.disabled)', @.onDeleteClick)
    @el.off('click', '.start_delete:not(.disabled)', @.onStartDeleteClick)

    @playerState.unbind('update', @.onStateUpdated)

  onNewClick: =>
    modals.NewAdvertisingModal.show()

  defineData: ->
    @list = _.sortBy(@playerState.advertisingRecords(), (ad)-> ad.expireAt)

    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

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

  onStateUpdated: (state)=>
    changes = state.changes()
    return unless changes.advertising?

    @.defineData()

    @.render()

    @.setupTimers()

  onOpenRouteClick: (e)->
    button = $(e.currentTarget)

    button.addClass('disabled')

    request.send('open_route', advertising_id: button.data('advertising-id'))

  onRouteOpened: (response)->
    console.log 'onRouteOpened', response

  onCreated: (response)=>
    unless response.is_error
      @.displayResult(
        null
        response
        position: "right bottom"
      )

  onDeleteClick: (e)=>
    button = $(e.currentTarget)

    @.displayConfirm(button,
      button:
        className: 'start_delete'
        data:
          'advertising-id': _.toInteger(button.data('advertising-id'))
      position: 'left bottom'
    )

  onStartDeleteClick: (e)=>
    button = $(e.currentTarget)
    return if button.data('type') == 'cancel'

    button.addClass('disabled')
    advertising_id = button.parents('.confirm_controls').data('advertising-id')

    @el.find("#ad_#{advertising_id} button").addClass('disabled')

    request.send('delete_advertising', advertising_id: advertising_id)

  onDeleted: (response)=>


module.exports = AdvertisingPage