InnerPage = require("../inner_page")
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')
ctx = require('../../context')

Transport = require('../../game_data').Transport
Route = require('../../game_data').Route
VisualTimer = require('../../lib').VisualTimer

class TruckingPage extends InnerPage
  className: "trucking inner_page"

  PER_PAGE = 3

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
    @el.find('.list').html(@.renderTemplate("routes/list"))

    @.setupTimers()

  setupTimers: ->
    for resource in @paginatedList
      timeDiff = Date.now() - resource.loadedAt

      if resource.completeIn? && resource.completeIn > 0
        @timers[resource.id] ?= new VisualTimer()
        @timers[resource.id].setElement($("#trucking_#{ resource.id } .timer .value"))
        @timers[resource.id].start(resource.completeIn - timeDiff)

  bindEventListeners: ->
    super

    request.bind('trucking_collected', @.onTruckingCollected)

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @el.on('click', '.collect:not(.disabled)', @.onCollectClick)

  unbindEventListeners: ->
    super

    request.unbind('trucking_collected', @.onTruckingCollected)

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.collect:not(.disabled)', @.onCollectClick)

  defineData: ->
    @list = _.sortBy((
      for id, resource of @playerState.trucking
        transportList = []

        for tId in resource.transportIds
          tState = @playerState.transport[tId]
          transportList.push(Transport.find(tState.typeId))

        _.assignIn({
          id: id
          route: Route.find(resource.routeId)
          transportList: transportList
        }, resource)
    ), (r)-> r.completeIn)

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

    @.displayResult(null,
      type: 'success'
      reward: response.data.reward
    )


module.exports = TruckingPage
