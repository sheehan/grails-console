const del           = require('del');
const GrailsBuilder = require('./grails-builder');

module.exports = function (gulp, paths) {

    const grailsBuilder = new GrailsBuilder({
        outputDir:   './grails2/plugin/grails-app/views/console/',
        relativeDir: './grails2/plugin/web-app/',
        webDir:      './grails2/plugin/web-app/',
        faviconWrap: path => `<link rel="icon" type="image/png" href="\${resource(file: '${path}', plugin: 'console')}" />`,
        jsWrap:      path => `<script type="text/javascript" src="\${resource(file: '${path}', plugin: 'console')}" ></script>`,
        cssWrap:     path => `<link rel="stylesheet" media="screen" href="\${resource(file: '${path}', plugin: 'console')}" />`,
        paths:       paths
    });

    gulp.task('grails2:clean', () => {
        return del.sync([
            './grails2/plugin/web-app/**/*',
            './grails2/plugin/grails-app/views/console/_*.gsp'
        ]);
    });

    gulp.task('grails2:debug', ['debug', 'grails2:clean'], () => {
        grailsBuilder.build(true);
    });

    gulp.task('grails2:release', ['release', 'grails2:clean'], () => {
        grailsBuilder.build(false);
    });
};