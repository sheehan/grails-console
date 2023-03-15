import { deleteSync } from 'del';

import { build } from './grails-builder.js';
import { paths } from './paths.js';

const options = {
    outputDir:   './grails2/plugin/grails-app/views/console/',
    relativeDir: './grails2/plugin/web-app/',
    webDir:      './grails2/plugin/web-app/',
    faviconWrap: path => `<link rel="icon" type="image/png" href="\${resource(file: '${path}', plugin: 'console')}" />`,
    jsWrap:      path => `<script type="text/javascript" src="\${resource(file: '${path}', plugin: 'console')}" ></script>`,
    cssWrap:     path => `<link rel="stylesheet" media="screen" href="\${resource(file: '${path}', plugin: 'console')}" />`,
    paths:       paths
};

export const grails2CleanTask = (cb) => {
    deleteSync([
        './grails2/plugin/web-app/**/*',
        './grails2/plugin/grails-app/views/console/_*.gsp',
    ]);
    cb();
};

export const grails2DebugTask = () => {
    return build(true, options);
};

export const grails2ReleaseTask = () => {
    return build(false, options);
};
