const del           = require('del');
const GrailsBuilder = require('./grails-builder');

module.exports = function (gulp, paths) {

    const grailsBuilder = new GrailsBuilder({
        outputDir:   './grails3/plugin/grails-app/views/console/',
        relativeDir: './grails3/plugin/src/main/resources/static',
        webDir:      './grails3/plugin/src/main/resources/static/console/',
        faviconWrap: path => `<link rel="icon" type="image/png" href="\${resource(file: '${path}')}" />`,
        jsWrap:      path => `<script type="text/javascript" src="\${resource(file: '${path}')}" ></script>`,
        cssWrap:     path => `<link rel="stylesheet" media="screen" href="\${resource(file: '${path}')}" />`,
        paths:       paths
    });

    gulp.task('grails3:clean', () => {
        return del.sync([
            './grails3/plugin/src/main/resources/static/**/*',
            './grails3/plugin/grails-app/views/console/_*.gsp'
        ]);
    });

    gulp.task('grails3:debug', ['debug', 'grails3:clean'], () => {
        grailsBuilder.build(true);
    });

    gulp.task('grails3:release', ['release', 'grails3:clean'], () => {
        grailsBuilder.build(false);
    });
};