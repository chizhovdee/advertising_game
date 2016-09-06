gulp = require("gulp")
coffee = require('gulp-coffee')
gutil = require("gulp-util")
notify = require('gulp-notify')

gulp.task('coffee-compile', ->
  return gulp.src(['**/*.coffee', '!./tasks/**/*.coffee'])
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .on('error', notify.onError({
      title: "COFFEE client dir ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
  .pipe(gulp.dest('./build'))
)