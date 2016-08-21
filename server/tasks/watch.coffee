gulp = require("gulp")

gulp.task('watch', ->
  gulp.watch('./app/**/*.coffee', ["build"])

  gulp.watch('./app/views/**/*.ejs', ["views-copy"])
)
