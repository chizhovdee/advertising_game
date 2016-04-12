Base = require("./base")

class EmployeeType extends Base
  @configure 'EmployeeType', 'key', 'salary'

  name: ->
    I18n.t("game_data.employee_types.#{@key}")

module.exports = EmployeeType