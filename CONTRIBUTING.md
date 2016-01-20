# Contributing

This plugin uses [Gulp](http://gulpjs.com/) to build its resources.

## Building

1. Change to the project's root directory.
1. Install project dependencies with `npm install`.
1. Build the resources with `gulp release-all`.

## Gulp tasks

| Task | Description |
| --- | --- |
| watch   | Watches for file changes and update.|
| test    | Runs all jasmine tests. |
| grails2:debug   | Builds all debug resources and copy to grails2.|
| grails3:debug   | Builds all debug resources and copy to grails3.|
| debug-all       | Builds all debug resources and copy to grails2 and grails3.|
| grails2:release | Builds all release resources and copy to grails2.|
| grails3:release | Builds all release resources and copy to grails3.|
| release-all     | Builds all release resources and copy to graisl2 and grails3.|

## File structure

    .
    ├── grails2
    │   ├── app             # grails2 test app 
    │   └── plugin          # grails2 plugin    
    ├── grails3
    │   ├── app             # grails3 test app
    │   └── plugin          # grails3 plugin
    ├── web                 # shared web resources
    │   ├── app             # coffeescript
    │   ├── img
    │   ├── spec            # jasmine
    │   ├── styles          # less
    │   ├── templates       # handlebars templates
    │   └── vendor          # vendor libs
    ├── gulpfile.js
    └── package.json

## Running

When developing, use `grails2/app` and `grails3/app`.


