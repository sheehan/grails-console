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
| json    | Creates a manifest of project resources in `grails-app/conf/console.json` |
| test    | Runs all jasmine tests. |
| debug   | Builds all debug resources to `web-app/dist/debug`.|
| release | Builds all release resources to `web-app/dist/release`.|

## File structure

Structure for front-end resources:

    .
    ├── grails-app
    │   └── conf
    │       └── console.json   # resource manifest
    ├── web-app
    │   ├── dist
    │   │   ├── debug
    │   │   └── release
    │   ├── spec               # jasmine
    │   ├── src
    │   │   ├── app            # coffeescript
    │   │   ├── img
    │   │   ├── styles         # less
    │   │   └── templates      # handlebars templates
    │   └── vendor             # vendor libs
    ├── Gruntfile.coffee
    └── package.json

## Running

When developing, include the plugin as an inline dependency in BuildConfig.groovy:

    grails.plugin.location.console = '../path/to/grails-console'

Configuration:

    grails.plugin.console.debug = true  // use the debug resources
    grails.plugin.console.reload = true // always reload the console.json file


