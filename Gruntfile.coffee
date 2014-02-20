module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    app:
      js:
        debug: [
          'web-app/dist/debug/jst.js'
          'web-app/dist/debug/app/app.js'
          'web-app/dist/debug/app/*/**/*.js'
        ]

        release: 'web-app/dist/release/app.js'

      css:
        debug:
          'web-app/dist/debug/app.css'

        release:
          'web-app/dist/release/app.css'

    vendor:
      js: [
        'web-app/vendor/js/libs/jquery-1.7.1.min.js'
        'web-app/vendor/jquery-ui-1.10.3/jquery-ui.min.js'
        'web-app/vendor/bootstrap/js/bootstrap.min.js'
        'web-app/vendor/js/libs/underscore-min.js'
        'web-app/vendor/js/libs/backbone-min.js'
        'web-app/vendor/js/libs/backbone.marionette.min.js'
        'web-app/vendor/js/libs/handlebars.runtime.js'
        'web-app/vendor/jquery-layout/js/jquery.layout-latest.min.js'
        'web-app/vendor/js/plugins/jquery.hotkeys.js'
        'web-app/vendor/codemirror-3.18/lib/codemirror.js'
        'web-app/vendor/codemirror-3.18/mode/groovy/groovy.js'
      ]
      css: [
        'web-app/vendor/bootstrap/css/bootstrap.min.css'
        'web-app/vendor/font-awesome-4.0.3/css/font-awesome.css'
        'web-app/vendor/codemirror-3.18/lib/codemirror.css'
        'web-app/vendor/codemirror-3.18/theme/lesser-dark.css'
        'web-app/vendor/jquery-layout/css/jquery.layout.css'
        'web-app/vendor/jquery-ui-1.10.3/jquery-ui.min.css'
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
          'web-app/dist/debug/jst.js': 'web-app/src/templates/**/*.hbs'

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
        dest: 'web-app/dist/debug/app'
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
          'web-app/dist/debug/app.css': 'web-app/src/styles/app.less'

    copy:
      debug:
        expand: true,
        cwd: 'web-app/src/img'
        src: '**/*'
        dest: 'web-app/dist/debug/img'
      release:
        files: [
          { expand: true, cwd: 'web-app/src/img', src: '**/*', dest: 'web-app/dist/release/img' }
          { expand: true, cwd: 'web-app/vendor', src: '**/*', dest: 'web-app/dist/release/vendor' }
          { src: 'web-app/dist/debug/app.css', dest: '<%= app.css.release %>' }
        ]

    clean:
      dist: ['web-app/dist']
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