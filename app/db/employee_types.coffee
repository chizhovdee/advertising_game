EmployeeType = require('../game_data').EmployeeType

EmployeeType.define('warehouse_manager', (obj)-> obj.salary = 100)

EmployeeType.define('hangar_manager', (obj)-> obj.salary = 200)

EmployeeType.define('sea_port_manager', (obj)-> obj.salary = 150)

EmployeeType.define('train_depot_manager', (obj)-> obj.salary = 200)

EmployeeType.define('garage_manager', (obj)-> obj.salary = 100)
