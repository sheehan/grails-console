'use strict';

const del         = require('del');
const gulp        = require('gulp');
const coffee      = require('gulp-coffee');
const concat      = require('gulp-concat');
const declare     = require('gulp-declare');
const handlebars  = require('gulp-handlebars');
const jasmine     = require('gulp-jasmine-phantom');
const less        = require('gulp-less');
const minifyCss   = require('gulp-minify-css');
const gutil       = require('gulp-util');
const watch       = require('gulp-watch');
const wrap        = require('gulp-wrap');

const timestamp = new Date().getTime();

const paths = {

    favicon: 'img/grails.logo.png',

    app: {
        css: {
            debug: [
                '/css/**/*.css'
            ],
            release: [
                `/css/app.${timestamp}.css`
            ]
        },
        js: {
            debug: [
                '/js/templates.js',
                '/js/app/app.js',
                '/js/app/*/**/*.js'
            ],
            release: [
                `/js/app.${timestamp}.js`
            ]
        }
    },
    vendor: {
        base: './web',
        css: [
            '/vendor/bootstrap/css/bootstrap.min.css',
            '/vendor/font-awesome-4.0.3/css/font-awesome.css',
            '/vendor/codemirror-5.2/lib/codemirror.css',
            '/vendor/codemirror-5.2/theme/lesser-dark.css',
            '/vendor/jquery-layout/css/jquery.layout.css',
            '/vendor/jquery-ui-1.10.3/jquery-ui.min.css'
        ],
        js: [
            '/vendor/js/libs/jquery-1.7.1.min.js',
            '/vendor/jquery-ui-1.10.3/jquery-ui.min.js',
            '/vendor/bootstrap/js/bootstrap.min.js',
            '/vendor/js/libs/underscore-min.js',
            '/vendor/js/libs/backbone-min.js',
            '/vendor/js/libs/backbone.marionette.min.js',
            '/vendor/js/libs/handlebars.runtime-v4.0.5.js',
            '/vendor/jquery-layout/js/jquery.layout-latest.min.js',
            '/vendor/js/plugins/jquery.hotkeys.js',
            '/vendor/codemirror-5.2/lib/codemirror.js',
            '/vendor/codemirror-5.2/mode/groovy/groovy.js'
        ]
    },
    test: ['./js/tests/**.js']
};

require('./gulp-tasks/grails2')(gulp, paths);
require('./gulp-tasks/grails3')(gulp, paths);

gulp.task('clean', () => {
    del.sync('./build');
});

gulp.task('templates', () => {
    return gulp.src('./web/templates/**/*.hbs')
        .pipe(handlebars({
            handlebars: require('handlebars')
        }))
        .pipe(wrap('Handlebars.template(<%= contents %>)'))
        .pipe(declare({
            namespace: 'JST',
            processName: filePath => filePath.replace(/^.*web\/templates\//, '').replace(/\.js$/, '')
        }))
        .pipe(concat('templates.js'))
        .pipe(gulp.dest('./build/debug/js/'));
});

gulp.task('coffee:app', () => {
    return gulp.src('./web/app/**/*.coffee')
        .pipe(coffee({bare: false, join: false}).on('error', gutil.log))
        .pipe(gulp.dest('./build/debug/js/app/'));
});

gulp.task('coffee:spec', () => {
    return gulp.src('./web/spec/**/*.coffee')
        .pipe(coffee({bare: false, join: false}).on('error', gutil.log))
        .pipe(gulp.dest('./build/spec/'));
});

gulp.task('less', () => {
    return gulp.src('./web/styles/**/*.less')
        .pipe(less())
        .pipe(gulp.dest('./build/debug/css/'));
});

gulp.task('concat:js', ['debug'], () => {
    return gulp.src(paths.vendor.js.map(path => paths.vendor.base + path)
        .concat(paths.app.js.debug.map(path => './build/debug' + path))
    )
        .pipe(concat(`app.${timestamp}.js`))
        .pipe(gulp.dest('./build/release/js/'));
});

gulp.task('concat:css', ['debug'], () => {
    return gulp.src(paths.app.css.debug.map(path => './build/debug' + path))
        .pipe(minifyCss({keepBreaks: true}))
        .pipe(concat(`app.${timestamp}.css`))
        .pipe(gulp.dest('./build/release/css/'));
});

gulp.task('test', ['clean', 'templates', 'coffee:app', 'coffee:spec'], () => {
    var vendorPaths = paths.vendor.js
        .concat(['/vendor/js/plugins/jasmine-jquery.js'])
        .map(path => paths.vendor.base + path)
        .concat(paths.app.js.debug.map(path => './build/debug' + path));

    return gulp.src('./build/spec/**/*spec.*')
        .pipe(jasmine({
            helpers: './build/spec/**/*helper.*',
            integration: true,
            vendor: vendorPaths
        }));
});

gulp.task('watch', function () {
    gulp.watch(['./web/**/*', 'gulpfile.js'], ['debug-all']);
});

gulp.task('debug', ['clean', 'templates', 'coffee:app', 'less']);
gulp.task('release', ['debug', 'concat:js', 'concat:css']);

gulp.task('debug-all', ['grails2:debug', 'grails3:debug']);
gulp.task('release-all', ['grails2:release', 'grails3:release']);

//gulp.task('default', ['build']);