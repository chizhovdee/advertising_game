gulp = require("gulp")
eco = require('gulp-eco')
concat = require('gulp-concat')
notify = require('gulp-notify')
gutil = require("gulp-util")

eco_files_path = "./views/**/*.eco"
compiled_eco_js = "JST.js"
build_path = "./build"

gulp.task("eco-compile", ->
  gulp.src(eco_files_path)
  .pipe(eco({nameExport: "module.exports", basePath: './views'}).on('error', gutil.log))
  .on('error', notify.onError({
      title: "ECO templates ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
  .pipe(concat(compiled_eco_js))
  .pipe(gulp.dest(build_path))
)