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
    timeDiff = Date.now() - @playerState.propertiesUpdatedAt

    for resource in @paginatedList
      if resource.expireTimeLeft > 0
        @expireTimers[resource.id] ?= new VisualTimer()
        @expireTimers[resource.id].setElement($("#ad_#{ resource.id } .life_timer .value"))
        @expireTimers[resource.id].start(resource.expireTimeLeft - timeDiff)

      if resource.nextRouteTimeLeft > 0
        @nextRouteTmers[resource.id] ?= new VisualTimer()
        @nextRouteTmers[resource.id].setElement($("#ad_#{ resource.id } .next_route_timer .value"))
        @nextRouteTmers[resource.id].start(resource.nextRouteTimeLeft - timeDiff)

  bindEventListeners: ->
    super

    request.bind('route_opened', @.onRouteOpened)
    request.bind('advertising_created', @.onCreated)

    @el.on('click', '.new', @.onNewClick)
    @el.on('click', '.open_route', @.onOpenRouteClick)
    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @playerState.bind('update', @.onStateUpdated)

  unbindEventListeners: ->
    super

    request.unbind('route_opened', @.onRouteOpened)
    request.unbind('advertising_created', @.onCreated)

    @el.off('click', '.new', @.onNewClick)
    @el.off('click', '.open_route', @.onOpenRouteClick)
    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @playerState.unbind('update', @.onStateUpdated)

  onNewClick: =>
    modals.NewAdvertisingModal.show()

  defineData: ->
    console.log @list = _.sortBy((
      for id, resource of @playerState.advertising
        _.assignIn({
          id: id
          type: AdvertisingType.find(resource.typeId)
        }, resource)
    ), (ad)-> ad.expireAt)

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


module.exports = AdvertisingPage