export const timestamp = new Date().getTime();

export const paths = {
    favicon: 'img/grails.logo.png',

    app: {
        css: {
            debug: [
                '/css/**/*.css'
            ],
            release: [
                `/css/app.${timestamp}.css`
            ],
        },
        js: {
            debug: [
                '/js/templates.js', '/js/app/app.js', '/js/app/*/**/*.js'
            ],
            release: [
                `/js/app.${timestamp}.js`
            ],
        },
    },
    vendor: {
        base: './web',
        css: [
            '/vendor/bootstrap/css/bootstrap.min.css',
            '/vendor/font-awesome-4.0.3/css/font-awesome.css',
            '/vendor/codemirror-5.25.2/lib/codemirror.css',
            '/vendor/codemirror-5.25.2/theme/lesser-dark.css',
            '/vendor/jquery-layout/css/jquery.layout.css',
            '/vendor/jquery-ui-1.10.3/jquery-ui.min.css',
        ],
        js: [
            '/vendor/js/libs/jquery-1.7.1.min.js',
            '/vendor/jquery-ui-1.10.3/jquery-ui.min.js',
            '/vendor/bootstrap/js/bootstrap.min.js',
            '/vendor/js/libs/underscore-min.js',
            '/vendor/js/libs/backbone-min.js',
            '/vendor/js/libs/backbone.marionette.min.js',
            '/vendor/js/libs/handlebars.runtime-v4.7.6.js',
            '/vendor/jquery-layout/js/jquery.layout-latest.min.js',
            '/vendor/js/plugins/jquery.hotkeys.js',
            '/vendor/codemirror-5.25.2/lib/codemirror.js',
            '/vendor/codemirror-5.25.2/mode/groovy/groovy.js',
        ],
    },
    test: [
        './js/tests/**.js'
    ],
};
