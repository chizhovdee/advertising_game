gulp = require("gulp")
coffee = require('gulp-coffee')
gutil = require("gulp-util")
notify = require('gulp-notify')

build_path = "./build/"

gulp.task('coffee-compile', ->
  gulp.src('./app/**/*.coffee')
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .on('error', notify.onError({
      title: "COFFEE server dir ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
  .pipe(gulp.dest(build_path))
)
