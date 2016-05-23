InnerPage = require("../inner_page")
modals = require('../modals')
request = require("../../lib/request")
Pagination = require("../../lib").Pagination
ctx = require('../../context')

class AdvertisingPage extends InnerPage
  className: 'advertising inner_page'

  PER_PAGE = 4

  show: ->
    super

    @loading = true

    @.defineData()

    @.render()

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
        }, resource)
    ), (ad)-> ad.completeAt)

    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

    @.render()

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