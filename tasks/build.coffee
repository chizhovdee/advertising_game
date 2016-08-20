gulp = require("gulp")
rev = require('gulp-rev')
revdelOriginal = require('gulp-rev-delete-original')
revCss =require('gulp-rev-css-url')

browserify = require('browserify')
source = require('vinyl-source-stream')
fs = require("fs")
concat = require('gulp-concat')
buffer = require('vinyl-buffer')
file = require('gulp-file')

del = require('del')

gulp.task("build", ["build:client", "build:server", "locales"])

gulp.task("build:client", ["prepare:client"], ->
  gulp.src('./public/assets/**')
  .pipe(rev())
  .pipe(revCss())
  .pipe(revdelOriginal())
  .pipe(gulp.dest("./public/assets/"))
  .pipe(rev.manifest(
      base: 'public/assets'
    ))
  .pipe(gulp.dest("./public/assets/"))
)

gulp.task("build:server", ['coffee-compile:server', 'server-views-copy'])

gulp.task("server-views-copy", ->
  gulp.src('./app/views/**/*.ejs')
  .pipe(gulp.dest("./build/views/"))
)

gulp.task("prepare:client", [
  'coffee-compile:client',
  'eco-compile',
  'client-vendors',
  'game_data:populate',
  'client-settings',
  'assets-timestamps',
  'stylesheets',
  'images'
], ->
  del.sync(['public/assets/*.js'])

  vendors = fs.readFileSync("./build/client/vendors.js")

  browserify("./build/client/main.js", {debug: false})
  .bundle()
  .pipe(source("application.js"))
  .pipe(gulp.dest("./public/assets/"))
  .pipe(file("vendor.js", vendors))
  .pipe(buffer())
  .pipe(concat("application.js"))
  .pipe(gulp.dest("./public/assets/"))
)