gulp = require("gulp")
browserify = require('browserify')
source = require('vinyl-source-stream')
fs = require("fs")
concat = require('gulp-concat')
buffer     = require('vinyl-buffer')
file = require('gulp-file')

gulp.task('watch', ->
  gulp.watch('../server/app/db/game_data/**/*.coffee', ["game-data-populate-browserify"])

  gulp.watch('./**/*.coffee', ["coffee-compile-browserify"])

  gulp.watch('./views/**/*.eco', ["eco-compile-browserify"])

  gulp.watch('./styles/**/*.scss', ["stylesheets"])

  gulp.watch('./config/locales/**/*.yml', ["compile-locales"])
)

browserifyConcat = ->
  vendors = fs.readFileSync("./build/client/vendors.js");

  browserify("./build/client/main.js", debug: false)
  .bundle()
  .pipe(source("application.js"))
  .pipe(gulp.dest("./public/assets/"))
  .pipe(file("vendor.js", vendors))
  .pipe(buffer())
  .pipe(concat("application.js"))
  .pipe(gulp.dest("./public/assets/"))


gulp.task("game-data-populate-browserify", ['game_data:populate'], ->
  browserifyConcat()
)

gulp.task("coffee-compile-browserify", ['coffee-compile'], ->
  browserifyConcat()
)

gulp.task("eco-compile-browserify", ['eco-compile'], ->
  browserifyConcat()
)
