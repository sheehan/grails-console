# Contributing

This plugin uses [Grunt](http://gruntjs.com/) to build its resources. To install the Grunt CLI run:

    npm install -g grunt-cli

## Building

1. Change to the project's root directory.
1. Install project dependencies with `npm install`.
1. Build the resources with `grunt release`.

## Grunt tasks

| Task | Description |
| --- | --- |
| watch   | Watches for file changes and updates `web-app/dist/debug`.|
| test    | Runs all jasmine tests. |
| debug   | Builds all debug resources to `web-app/dist/debug`.|
| release | Builds all release resources to `web-app/dist/release`.|

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


