# Игра симулятор "Траспортная компания"

## Установка
Требуется установить nodejs, postgresql не ниже версии 9.4. Далее в консоле:

    npm install -g gulp
    
    npm install supervisor -g
    
    npm install -g db-migrate
    
    npm install
    
Создайте файл .env
    
Создайте базу данных в Postgresql и запустите миграции    

    db-migrate up --config config/database.json -e development
        
## Сборка проекта и запуск
Далее запустите сборщик и сервер:    
    
    gulp
    
    npm start


## Соглашения по коду
- для отправки json от сервера клиенту осуществляется с помощью метода toJSON
- в формате json ключи имеют snake-нотацию, т.е. 'some_key': 'some value'
- свойства, методы, функции и переменные имеют camel-нотацию, т.е. someVar = 'some value', someMethod(),
  за исключением свойств, которые пришли из json из любого источника (базы данных, опции в методах и т.д.) 
  
## Сторонние библиотеки и модули
### Сервер
- [Миграции](http://umigrate.readthedocs.org/projects/db-migrate/en/latest/)
- [Redis for Node](https://github.com/luin/ioredis)
- [Postgres for Node](https://github.com/vitaly-t/pg-promise)
- [Lodash](https://lodash.com/)

### Клиент
- [SpineJs](http://spinejs.com/)
- [noUiSlider](http://refreshless.com/nouislider/)
