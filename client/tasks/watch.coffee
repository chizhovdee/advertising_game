gulp = require("gulp")
browserify = require('browserify')
source = require('vinyl-source-stream')
fs = require("fs")
concat = require('gulp-concat')
buffer     = require('vinyl-buffer')
file = require('gulp-file')

serverAssetsDir = "../server/public/assets"

gulp.task('watch', ->
  gulp.watch('../server/app/db/game_data/**/*.coffee', ["game-data-json-browserify"])

  gulp.watch(['./**/*.coffee', '!./tasks/**/*.coffee'], ["coffee-compile-browserify"])

  gulp.watch('./views/**/*.eco', ["eco-compile-browserify"])

  gulp.watch('./styles/**/*.scss', ["stylesheets"])

  gulp.watch('./locales/**/*.yml', ["compile-locales"])
)

browserifyConcat = ->
  vendors = fs.readFileSync("./build/vendors.js")

  browserify("./build/main.js", {debug: false})
  .bundle()
  .pipe(source("application.js"))
  .pipe(gulp.dest(serverAssetsDir))
  .pipe(file("vendor.js", vendors))
  .pipe(buffer())
  .pipe(concat("application.js"))
  .pipe(gulp.dest(serverAssetsDir))


gulp.task("game-data-json-browserify", ['game_data_json'], ->
  browserifyConcat()
)

gulp.task("coffee-compile-browserify", ['coffee-compile'], ->
  browserifyConcat()
)

gulp.task("eco-compile-browserify", ['eco-compile'], ->
  browserifyConcat()
)
