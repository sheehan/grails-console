'use strict';

import { deleteSync } from 'del';
import gulp from 'gulp';
import coffee from 'gulp-coffee';
import concat from 'gulp-concat';
import declare from 'gulp-declare';
import gulpHandlebars from 'gulp-handlebars';
import jasmine from 'gulp-jasmine-phantom';
import gulpLess from 'gulp-less';
import Handlebars from 'handlebars';
import cleanCss from 'gulp-clean-css';
import gutil from 'gulp-util';
import wrap from 'gulp-wrap';

import { grails3CleanTask, grails3DebugTask, grails3ReleaseTask } from './gulp-tasks/grails3.js';
import { grails2CleanTask, grails2DebugTask, grails2ReleaseTask } from './gulp-tasks/grails2.js';
import { paths, timestamp } from './gulp-tasks/paths.js';

export const clean = (cb) => {
    deleteSync('./build');
    cb();
};

export const templates = () => {
    return gulp.src('./web/templates/**/*.hbs')
        .pipe(gulpHandlebars({
            handlebars: Handlebars
        }))
        .pipe(wrap('Handlebars.template(<%= contents %>)'))
        .pipe(declare({
            namespace: 'JST',
            processName: filePath => filePath.replace(/^.*web\/templates\//, '').replace(/\.js$/, '')
        }))
        .pipe(concat('templates.js'))
        .pipe(gulp.dest('./build/debug/js/'));
};

const coffeeApp = () => {
    return gulp.src('./web/app/**/*.coffee')
        .pipe(coffee({bare: false, join: false}).on('error', gutil.log))
        .pipe(gulp.dest('./build/debug/js/app/'));
};

const coffeeSpec = () => {
    return gulp.src('./web/spec/**/*.coffee')
        .pipe(coffee({bare: false, join: false}).on('error', gutil.log))
        .pipe(gulp.dest('./build/spec/'));
};

export const less = () => {
    return gulp.src('./web/styles/**/*.less')
        .pipe(gulpLess())
        .pipe(gulp.dest('./build/debug/css/'));
};

export const concatJsTask = () => {
    return gulp.src(paths.vendor.js.map(path => paths.vendor.base + path)
        .concat(paths.app.js.debug.map(path => './build/debug' + path))
    )
        .pipe(concat(`app.${timestamp}.js`))
        .pipe(gulp.dest('./build/release/js/'));
};

const concatCssTask = () => {
    return gulp.src(paths.app.css.debug.map(path => './build/debug' + path))
        .pipe(cleanCss({ keepBreaks: true }))
        .pipe(concat(`app.${timestamp}.css`))
        .pipe(gulp.dest('./build/release/css/'));
};

const testTask = () => {
    var vendorPaths = paths.vendor.js
        .concat(['/vendor/js/plugins/jasmine-jquery.js'])
        .map(path => paths.vendor.base + path)
        .concat(paths.app.js.debug.map(path => './build/debug' + path));

    // doesn't work due to a bug related to 'fs' module in 'gulp-jasmine-phantom'
    return gulp.src('./build/spec/**/*spec.*')
        .pipe(jasmine({
            helpers: './build/spec/**/*helper.*',
            integration: true,
            vendor: vendorPaths
        }));
};

export const test = gulp.series(clean, templates, coffeeApp, coffeeSpec, testTask);

export const watch = (cb) => {
    gulp.watch(['./web/**/*', 'gulpfile.js'], gulp.series(debugAll));
    cb();
};

export const debug = gulp.series(clean, templates, coffeeApp, less);
export const release = gulp.series(debug, concatJsTask, concatCssTask);

export const concatJs = gulp.series(debug, concatJsTask);
export const concatCss = gulp.series(debug, concatCssTask);

export const grails2Clean = gulp.series(grails2CleanTask);
export const grails2Debug = gulp.series(debug, grails2CleanTask, grails2DebugTask);
export const grails2Release = gulp.series(release, grails2CleanTask, grails2ReleaseTask);

export const grails3Clean = gulp.series(grails3CleanTask);
export const grails3Debug = gulp.series(debug, grails3CleanTask, grails3DebugTask);
export const grails3Release = gulp.series(release, grails3CleanTask, grails3ReleaseTask);

export const debugAll = gulp.series(grails2Debug, grails3Debug);
export const releaseAll = gulp.series(grails2Release, grails3Release);
export const cleanAll = gulp.series(clean, grails2Clean, grails3Clean);

//gulp.task('default', ['build']);
