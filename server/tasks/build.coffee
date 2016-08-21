gulp = require("gulp")

source = require('vinyl-source-stream')
fs = require("fs")
concat = require('gulp-concat')
buffer = require('vinyl-buffer')
file = require('gulp-file')

gulp.task("build", ['coffee-compile', 'views-copy'])

gulp.task("views-copy", ->
  gulp.src('./app/views/**/*.ejs')
  .pipe(gulp.dest("./build/views/"))
)
