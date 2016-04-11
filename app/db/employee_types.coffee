EmployeeType = require('../game_data').EmployeeType

EmployeeType.define('storehouse_manager', (obj)-> obj.salary = 100)

EmployeeType.define('hangar_manager', (obj)-> obj.salary = 200)

EmployeeType.define('port_manager', (obj)-> obj.salary = 150)

EmployeeType.define('railstation_manager', (obj)-> obj.salary = 200)

EmployeeType.define('garage_manager', (obj)-> obj.salary = 100)

EmployeeType.define('researcher', (obj)-> obj.salary = 100)

EmployeeType.define('cargo_manager', (obj)-> obj.salary = 200)

EmployeeType.define('driver', (obj)-> obj.salary = 50)

# TODO mechanics
