'use strict';

const gulp        = require('gulp');
const concat      = require('gulp-concat');
const merge       = require('merge-stream');
const mkdirp      = require('mkdirp');
const through     = require('through2');
const path        = require('path');

const wrapPath = (relativeDir, fcn) => {
    return through.obj(function(file, encoding, callback) {
        let requirePath = path.relative(relativeDir, path.resolve(file.path));
        let tag = fcn(requirePath);
        file.contents = new Buffer(tag);
        return callback(null, file);
    })
};

class GrailsBuilder {
    constructor(options) {
        this.outputDir = options.outputDir;
        this.relativeDir = options.relativeDir;
        this.webDir = options.webDir;
        this.faviconWrap = options.faviconWrap;
        this.jsWrap = options.jsWrap;
        this.cssWrap = options.cssWrap;
        this.paths = options.paths;
    }

    build(isDebug) {
        let appSrc, jsSrc, cssSrc;
        if (isDebug) {
            appSrc = './build/debug/**/*';
            jsSrc = this.paths.vendor.js.concat(this.paths.app.js.debug).map(path => this.webDir + path);
            cssSrc = this.paths.vendor.css.concat(this.paths.app.css.debug).map(path => this.webDir + path);
        } else {
            appSrc = './build/release/**/*';
            jsSrc = this.paths.app.js.release.map(path => this.webDir + path);
            cssSrc = this.paths.vendor.css.concat(this.paths.app.css.release).map(path => this.webDir + path);
        }

        merge([
            gulp.src(appSrc),
            gulp.src('./web/img/**/*', {base: './web/'}),
            gulp.src('./web/vendor/**/*', {base: './web/'})
        ]).pipe(gulp.dest(this.webDir)).on('end', () => {
            mkdirp(this.outputDir);

            gulp.src([this.paths.favicon].map(path => this.webDir + path))
                .pipe(wrapPath(this.relativeDir, this.faviconWrap))
                .pipe(concat('_favicon.gsp'))
                .pipe(gulp.dest(this.outputDir));

            gulp.src(jsSrc)
                .pipe(wrapPath(this.relativeDir, this.jsWrap))
                .pipe(concat('_js.gsp'))
                .pipe(gulp.dest(this.outputDir));

            gulp.src(cssSrc)
                .pipe(wrapPath(this.relativeDir, this.cssWrap))
                .pipe(concat('_css.gsp'))
                .pipe(gulp.dest(this.outputDir));
        });
    }
}

module.exports = GrailsBuilder;