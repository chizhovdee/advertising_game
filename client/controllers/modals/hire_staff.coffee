Modal = require("../modal")
Pagination = require("../../lib").Pagination
EmployeeType = require('../../game_data').EmployeeType
request = require("../../lib").request

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

    @el.on('click', '.employee_type:not(.disabled) .package .control', @.onPackControlClick)
    @el.on('click', '.employee_type .hire:not(.disabled)', @.onHireButtonClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.list .paginate:not(.disabled)', @.onListPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

    @el.off('click', '.employee_type:not(.disabled) .package .control', @.onPackControlClick)
    @el.off('click', '.employee_type .hire:not(.disabled)', @.onHireButtonClick)

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

  onPackControlClick: (e)=>
    controlEl = $(e.currentTarget)
    controlEl.parents('.price').find('.package').removeClass('checked')
    packageEl = controlEl.parents('.package')
    packageEl.addClass('checked')

    hireButton = packageEl.parents('.employee_type').find('.hire')
    hireButton.removeClass('disabled')
    hireButton.data('package', packageEl.data('package'))

  onHireButtonClick: (e)=>
    buttonEl = $(e.currentTarget)
    buttonEl.parents('.employee_type').addClass('disabled')
    buttonEl.addClass('disabled')

    request.send('hire_staff',
      employee_type: buttonEl.data('employee-type')
      package: buttonEl.data('package')
    )

module.exports = HireStaffModal