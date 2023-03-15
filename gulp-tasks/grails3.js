import { deleteSync } from 'del';

import { build } from './grails-builder.js';
import { paths } from './paths.js';

const options = {
    outputDir:   './grails3/plugin/grails-app/views/console/',
    relativeDir: './grails3/plugin/src/main/resources/static',
    webDir:      './grails3/plugin/src/main/resources/static/console/',
    faviconWrap: path => `<link rel="icon" type="image/png" href="\${resource(file: '${path}')}" />`,
    jsWrap:      path => `<script type="text/javascript" src="\${resource(file: '${path}')}" ></script>`,
    cssWrap:     path => `<link rel="stylesheet" media="screen" href="\${resource(file: '${path}')}" />`,
    paths:       paths
};

export const grails3CleanTask = (cb) => {
    deleteSync([
        './grails3/plugin/src/main/resources/static/**/*',
        './grails3/plugin/grails-app/views/console/_*.gsp',
    ]);
    cb();
};

export const grails3DebugTask = () => {
    return build(true, options);
};

export const grails3ReleaseTask = () => {
    return build(false, options);
};
