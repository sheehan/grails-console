module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    app:
      js:
        debug: [
          'web-app/js/console/debug/jst.js'
          'web-app/js/console/debug/app/app.js'
          'web-app/js/console/debug/app/*/**/*.js'
        ]

        release: 'web-app/js/console/release/app.js'

      css:
        debug:
          'web-app/css/console/debug/app.css'

        release:
          'web-app/css/console/release/app.css'

    vendor:
      js: [
        'web-app/js/console/jquery-1.11.1.min.js'
        'web-app/js/console/jquery-ui-1.11.2.min.js'
        'web-app/js/console/bootstrap-3.2.0.min.js'
        'web-app/js/console/underscore-1.7.0.min.js'
        'web-app/js/console/backbone-1.0.0.min.js'
        'web-app/js/console/backbone.marionette-1.1.0.min.js'
        'web-app/js/console/handlebars.runtime-1.0.0.js'
        'web-app/js/console/jquery.layout-1.4.3.min.js'
        'web-app/js/console/jquery.hotkeys-0.8.js'
        'web-app/js/console/codemirror-4.7.min.js'
      ]
      css: [
        'web-app/css/console/bootstrap-3.2.0/bootstrap.min.css'
        'web-app/css/console/font-awesome-4.2.0/font-awesome.min.css'
        'web-app/css/console/codemirror-4.7/codemirror.css'
        'web-app/css/console/codemirror-4.7/theme/lesser-dark.css'
        'web-app/css/console/jquery-layout-1.4.3/layout-default.css'
        'web-app/css/console/jquery-ui-1.11.2/jquery-ui.min.css'
      ]

    concat:
      js:
        files: [
          src: ['<%= vendor.js %>', '<%= app.js.debug %>']
          dest: '<%= app.js.release %>'
        ]

    handlebars:
      compile:
        options:
          namespace: 'JST'
          processName: (filePath) ->
            filePath.replace(/^.*\/templates\//, '').replace(/\.hbs$/, '')

        files:
          'web-app/js/console/debug/jst.js': 'web-app/src/templates/**/*.hbs'

    jasmine:
      test:
        src: ['<%= app.js.debug %>']
        options:
          specs: 'web-app/target/spec/**/*spec.*'
          helpers: 'web-app/spec/*helper.js'
          keepRunner: true
          outfile: 'web-app/target/spec/SpecRunner.html'
          vendor: ['<%= vendor.js %>', 'web-app/vendor/js/plugins/jasmine-jquery.js']

    coffee:
      app:
        expand: true
        cwd: 'web-app/src/app'
        src: ['**/*.coffee']
        dest: 'web-app/js/console/debug/app'
        ext: '.js'
      spec:
        expand: true
        cwd: 'web-app/spec'
        src: ['**/*.coffee']
        dest: 'web-app/target/spec/'
        ext: '.js'

    less:
      app:
        files:
          'web-app/css/console/debug/app.css': 'web-app/src/styles/app.less'

    copy:
      debug:
        expand: true,
        cwd: 'web-app/src/img'
        src: '**/*'
        dest: 'web-app/images/console/debug'
      release:
        files: [
          { expand: true, cwd: 'web-app/src/img', src: '**/*', dest: 'web-app/images/console/release' }
          { src: 'web-app/css/console/debug/app.css', dest: '<%= app.css.release %>' }
        ]

    clean:
      dist: [
        'web-app/js/console/release'
        'web-app/js/console/debug'
        'web-app/css/console/release'
        'web-app/css/console/debug'
      ]
      spec: 'web-app/target/spec/'

    watch:
      jst:
        files: 'web-app/src/templates/**/*.hbs'
        tasks: ['handlebars:compile']
      less:
        files: 'web-app/src/styles/**/*.less'
        tasks: ['less:app']
      coffee:
        files: 'web-app/src/app/**/*.coffee'
        tasks: ['coffee:app']
      gruntfile:
        files: 'Gruntfile.coffee'
        tasks: ['debug']

  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-handlebars'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-less'

  grunt.registerTask 'json', 'Write resource config to file', ->
    app = grunt.config.get('app')
    vendor = grunt.config.get('vendor')

    json =
      debug:
        js: grunt.file.expand(vendor.js).concat grunt.file.expand(app.js.debug)
        css: grunt.file.expand(vendor.css).concat grunt.file.expand(app.css.debug)
      release:
        js: grunt.file.expand(app.js.release)
        css: grunt.file.expand(vendor.css).concat grunt.file.expand(app.css.release)
    grunt.file.write 'grails-app/conf/console.json', JSON.stringify(json, undefined, 2)

  grunt.registerTask 'default', ['debug']
  grunt.registerTask 'test', ['debug', 'clean:spec', 'coffee:spec', 'jasmine']
  grunt.registerTask 'debug', ['clean:dist', 'handlebars:compile', 'coffee:app', 'copy:debug', 'less:app', 'json']
  grunt.registerTask 'release', ['debug', 'copy:release', 'concat:js', 'json']