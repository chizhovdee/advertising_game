InnerPage = require("../inner_page")
modals = require('../modals')
request = require("../../lib/request")
Pagination = require("../../lib").Pagination
VisualTimer = require("../../lib").VisualTimer
ctx = require('../../context')
AdvertisingType = require('../../game_data').AdvertisingType

class AdvertisingPage extends InnerPage
  className: 'advertising inner_page'

  PER_PAGE = 3

  show: ->
    @playerState = ctx.get('playerState')

    super

    @loading = true

    @.defineData()

    @.render()

    @.setTimers()

  setTimers: ->
    for resource in @paginatedList
      continue if resource.lifeTimeLeft <= 0

      timer = new VisualTimer($("#ad_#{ resource.id } .life_timer .value"))
      timer.start(resource.lifeTimeLeft)

  render: ->
    @html(@.renderTemplate("advertising/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("advertising/list"))

  bindEventListeners: ->
    super

    @el.on('click', '.new', @.onNewClick)
    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @playerState.bind('update', @.onStateUpdated)

  unbindEventListeners: ->
    super

    @el.off('click', '.new', @.onNewClick)
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
    ), (ad)-> ad.completeAt)

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

  onStateUpdated: =>
    @.defineData()

    @.render()

    @.setTimers()


module.exports = AdvertisingPage