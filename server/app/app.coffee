express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
fs = require("fs")

app = express()

# загрузка и инициализации дополнительного функциоанала
boot = require('./boot')

boot.registerLodashMixins()
boot.loadGameData()

db = boot.setupPostgresqlConnection(app.get('env'))
redis = boot.setupRedisConnection(app.get('env'))
assetsManifest = boot.loadAssetsManifest()
assetsRevision = boot.loadAssetsRevision()

# собственные модули загружаем здесь
Ok = require('./lib/odnoklassniki')
middleware = require('./lib/middleware')

# view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs')

# сторонние модули middleware
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded(extended: false))
app.use(cookieParser())
#app.use(boot.createSession(app.get('env'))) нет пока надобности

# статика
publicDir = path.join(__dirname, '../public')
app.use(favicon(path.join(publicDir, 'favicon.ico')));
app.use(express.static(publicDir))

#app.use(Ok.middleware)
app.use(middleware.offlineUser)

app.use((req, res, next)->
  req.db = db
  req.redis = redis
  req.assetsManifest = assetsManifest
  req.assetsRevision = assetsRevision

  next()
)
app.use(middleware.currentPlayer)
app.use(middleware.requestParamsLog)
app.use(middleware.utils)
app.use(middleware.eventResponse)

require('./routes').setup(app)

# catch 404 and forward to error handler
app.use((req, res, next)->
  err = new Error('Page not Found')
  err.status = 404
  next(err)
)

# error handlers

# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use((err, req, res, next)->

  # TODO status
  #res.status(err.status || 500)

    if req.xhr
      res.sendEventError(err)
    else
      res.render('error',
        message: err.message
        error: err
      )
  )

# production error handler
# no stacktraces leaked to user
app.use((err, req, res, next)->
  res.status(err.status || 500)

  res.render('error',
    message: err.message,
    error: {}
  )
)

module.exports = app
