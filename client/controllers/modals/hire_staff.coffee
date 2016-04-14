Modal = require("../modal")
Pagination = require("../../lib").Pagination
EmployeeType = require('../../game_data').EmployeeType

class HireStaffModal extends Modal
  className: 'hire_staff modal'

  PER_PAGE = 3

  show: (@context)->
    super

    @list = EmployeeType.all()
    @listPagination = new Pagination(PER_PAGE)
    @paginatedList = @listPagination.paginate(@list, initialize: true)

    @listPagination.setSwitches(@list)

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('staff/hire')
    )

  renderList: ->
    @el.find('.list').html(@.renderTemplate("staff/employee_type_list"))

  bindEventListeners: ->
    super

    @el.on('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    #@el.on('click', '.price .pack')

  unbindEventListeners: ->
    super

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

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


module.exports = HireStaffModal