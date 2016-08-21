gulp = require('gulp')
del = require('del')

gulp.task('images', ->
  del.sync(['public/assets/**/*.+(jpg|jpeg|ico|png|gif|svg)'])

  gulp.src('./client/images/**')
  .pipe(gulp.dest('./public/assets'))
)