gulp = require("gulp")
fs = require("fs")
file = require('gulp-file')
del = require('del')

serverAssetsDir = '../server/public/assets'

gulp.task('game_data_json', ->
  del.sync("#{ serverAssetsDir }/game_data*",force: true)

  require('require-dir')('../../server/app/db', recurse: true )

  gameData = {}

  fs.readdirSync("../server/app/game_data/").forEach((name)->
    if name.indexOf(".coffee") > 0 && name not in ['base.coffee', 'index.coffee', 'good.coffee']
      baseName = name.split(".coffee")[0]

      resource = require("../../server/app/game_data/" + baseName)

      gameData[baseName] = resource.toJSON() if resource.isPublicForClient()
  )

  gameData['settings'] = require('../../server/app/client_settings')

  file('game_data.json', new Buffer(JSON.stringify(gameData)), { src: true })
  .pipe(gulp.dest(serverAssetsDir))
)
