BaseController = require("../base_controller")
Pagination = require("../../lib/index").Pagination
request = require('../../lib/request')
TransportGroup = require('../../game_data').TransportGroup

class TransportListLayout extends BaseController
  tabs: ['in_garage', 'in_shop', 'in_route']

  PER_PAGE = 3

  show: (options = {})->
    super

    @currentTab = @tabs[0]

    @groupKeys = _.map(TransportGroup.all(), (t)-> t.key)

    @currentGroupKey = options.transportGroupKey || 'truck'

    @listPagination = new Pagination(PER_PAGE)

    @.defineData()

    @.render()

  render: ->
    @html(@.renderTemplate("transport_list/index"))

  renderList: ->
    @el.find('.list').html(@.renderTemplate("transport_list/list"))

  renderGroups: ->
    @el.find('.groups').replaceWith(@.renderTemplate("transport_list/groups"))

  bindEventListeners: ->
    super

    @el.on('click', '.tabs .tab:not(.current)', @.onTabClick)
    @el.on('click', '.groups .group:not(.current)', @.onGroupClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.tabs .tab:not(.current)', @.onTabClick)
    @el.off('click', '.groups .group:not(.current)', @.onGroupClick)

  defineData: ->
    @list = []

    @transportGroup = TransportGroup.find(@currentGroupKey)

    switch @currentTab
      when 'in_garage'
        for record in @playerState.transportRecords()
          @list.push [record.model(), record]


    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

  onTabClick: (e)=>
    tabEl = $(e.currentTarget)

    @el.find('.tabs .tab').removeClass('current')

    tabEl.addClass('current')

    @currentTab = tabEl.data('tab')

    @currentGroupKey = @groupKeys[0]

    @.defineData()

    @.renderGroups()

    @.renderList()

  onGroupClick: (e)=>
    groupEl = $(e.currentTarget)

    @el.find('.groups .group').removeClass('current')
    groupEl.addClass('current')

    @currentGroupKey = groupEl.data('group-key')

    @.defineData()

    @.renderList()

module.exports = TransportListLayout
