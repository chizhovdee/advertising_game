gulp = require("gulp")

gulp.task('watch', ->
  gulp.watch('./app/**/*.coffee', ['coffee-compile'])

  gulp.watch('./app/views/**/*.ejs', ["views-copy"])
)
