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
    super

    @loading = true

    @.defineData()

    @.render()

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

  unbindEventListeners: ->
    super

    @el.off('click', '.new', @.onNewClick)
    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

  onNewClick: =>
    modals.NewAdvertisingModal.show()

  defineData: ->
    @playerState = ctx.get('playerState')

    @list = @playerState.advertising

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

module.exports = AdvertisingPage