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

#gulp.task("game_data:populate", ->
#  # удаляем сначала из кэша
##  fs.readdirSync("./app/db/").forEach((name)->
##    stats = fs.statSync("./app/db/#{name}")
##
##    if stats.isFile()
##      delete require.cache[require.resolve("../app/db/#{name}")]
##
##    if stats.isDirectory()
##      throw Error('is directory: Change logic in game_data:populate task')
##  )
##
##  fs.readdirSync("./app/game_data/").forEach((name)->
##    delete require.cache[require.resolve("../app/game_data/#{name}")]
##  )
#
#  require('require-dir')('../app/db', recurse: true )
#
#  gameData = {}
#
#  fs.readdirSync("../server/app/game_data/").forEach((name)->
#    if name.indexOf(".coffee") > 0 && name not in ['base.coffee', 'index.coffee', 'good.coffee']
#      baseName = name.split(".coffee")[0]
#
#      resource = require("../server/app/game_data/" + baseName)
#
#      gameData[baseName] = resource if resource.isPublicForClient()
#  )
#
#  tmpl = fs.readFileSync("./populate_game_data.ejs")
#
#  result = ejs.render(tmpl.toString(), data: gameData)
#
#  fs.mkdir('./build', ->
#    fs.writeFileSync("./build/populate_game_data.js", result)
#  )
#)