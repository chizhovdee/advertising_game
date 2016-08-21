gulp = require("gulp")
sass = require('gulp-sass')
notify = require('gulp-notify')
include = require('gulp-include')
gulpif = require('gulp-if')
fs = require("fs")
del = require('del')

gulp.task("stylesheets", ['sass-compile'], ->

  del.sync(['../server/public/assets/*.css'], force: true)

  gulp.src("./build/styles/application.css")
  .pipe(gulp.dest("../server/public/assets"))
)

gulp.task('sass-compile', ->
  gulp.src('./styles/application.scss')
  .pipe(include())
  .pipe(gulpif('application.scss', sass()))
  .on('error', notify.onError(
      title: "SASS ERROR"
      message: "Look in the console for details.\n <%= error.message %>"
    ))
  .pipe(gulpif('application.css', gulp.dest('./build/styles')))
)
