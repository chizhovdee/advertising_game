gulp = require("gulp")
rev = require('gulp-rev')
revdelOriginal = require('gulp-rev-delete-original')
fs = require('fs')

assetsDir = './public/assets'

gulp.task("build", ['coffee-compile', 'views-copy'])

gulp.task("views-copy", ->
  gulp.src('./app/views/**/*.ejs')
  .pipe(gulp.dest("./build/views/"))
)
