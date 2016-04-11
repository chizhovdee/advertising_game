_ = require("lodash")
Base = require("./base")

class EmployeeType extends Base
  salary: null # зарплата за одну единицу работы

  @configure()

  constructor: ->
    super

    @salary = null

  validationForDefine: ->
    return new Error('undefined salary') unless @salary?
    
module.exports = EmployeeType