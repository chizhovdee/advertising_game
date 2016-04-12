_ = require("lodash")
Base = require("./base")

class EmployeeType extends Base
  salary: null # зарплата за одну единицу работы

  @configure(publicForClient: true)

  constructor: ->
    super

    @salary = null

  validationForDefine: ->
    return new Error('undefined salary') unless @salary?

  toJSON: ->
    _.assign(
      salary: @salary
      ,
      super
    )
    
module.exports = EmployeeType