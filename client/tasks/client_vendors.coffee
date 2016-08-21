gulp = require("gulp")
concat = require('gulp-concat')

gulp.task('concat-vendors', ->
  gulp.src("./vendor/**/*.js")
  .pipe(concat("vendors.js"))
  .pipe(gulp.dest("./build"))
)
