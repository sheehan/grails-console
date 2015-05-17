module.exports = (grunt) ->

  debugDir = "web-app/dist/debug"
  releaseDir = "web-app/dist/release"
  vendorDir = "web-app/vendor"
  webSrcDir = '../web'
  targetDir = 'web-app/target'

  vendorJs = [
    '/js/libs/jquery-1.7.1.min.js'
    '/jquery-ui-1.10.3/jquery-ui.min.js'
    '/bootstrap/js/bootstrap.min.js'
    '/js/libs/underscore-min.js'
    '/js/libs/backbone-min.js'
    '/js/libs/backbone.marionette.min.js'
    '/js/libs/handlebars.runtime-v3.0.1.js'
    '/jquery-layout/js/jquery.layout-latest.min.js'
    '/js/plugins/jquery.hotkeys.js'
    '/codemirror-5.2/lib/codemirror.js'
    '/codemirror-5.2/mode/groovy/groovy.js'
  ]

  vendorCss = [
    '/bootstrap/css/bootstrap.min.css'
    '/font-awesome-4.0.3/css/font-awesome.css'
    '/codemirror-5.2/lib/codemirror.css'
    '/codemirror-5.2/theme/lesser-dark.css'
    '/jquery-layout/css/jquery.layout.css'
    '/jquery-ui-1.10.3/jquery-ui.min.css'
  ]

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    app:
      js:
        debug: [
          "#{debugDir}/jst.js"
          "#{debugDir}/app/app.js"
          "#{debugDir}/app/*/**/*.js"
        ]

        release: "#{releaseDir}/app.js"

      css:
        debug:
          "#{debugDir}/app.css"

        release:
          "#{releaseDir}/app.css"

    vendor:
      js: vendorJs.map (it) -> "#{debugDir}/vendor#{it}"
      css:
        debug: vendorCss.map (it) -> "#{debugDir}/vendor#{it}"
        release: vendorCss.map (it) -> "#{releaseDir}/vendor#{it}"

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

        files: [
          src: "#{webSrcDir}/templates/**/*.hbs", dest: "#{debugDir}/jst.js"
        ]

    jasmine:
      test:
        src: ['<%= app.js.debug %>']
        options:
          specs: "#{targetDir}/spec/**/*spec.*"
          helpers: "#{webSrcDir}/spec/*helper.js"
          keepRunner: true
          outfile: "#{targetDir}/spec/SpecRunner.html"
          vendor: ['<%= vendor.js %>', "#{debugDir}/vendor/js/plugins/jasmine-jquery.js"]

    coffee:
      app:
        expand: true
        cwd: "#{webSrcDir}/app"
        src: ['**/*.coffee']
        dest: "#{debugDir}/app"
        ext: '.js'
      spec:
        expand: true
        cwd: "#{webSrcDir}/spec"
        src: ['**/*.coffee']
        dest: "#{targetDir}/spec/"
        ext: '.js'

    less:
      app:
        files: [
          src: "#{webSrcDir}/styles/app.less", dest: "#{debugDir}/app.css"
        ]

    copy:
      debug:
        files: [
          {expand: true, cwd: "#{webSrcDir}/img", src: '**/*', dest: "#{debugDir}/img"}
          {expand: true, cwd: "#{webSrcDir}/vendor", src: '**/*', dest: "#{debugDir}/vendor"}
        ]
      release:
        files: [
          { expand: true, cwd: "#{webSrcDir}/img", src: '**/*', dest: "#{releaseDir}/img" }
          { expand: true, cwd: "#{webSrcDir}/vendor", src: '**/*', dest: "#{releaseDir}/vendor" }
          { src: "#{debugDir}/app.css", dest: '<%= app.css.release %>' }
        ]

    clean:
      dist: ['web-app/dist']
      debug: [debugDir]
      spec: "#{targetDir}/spec/"

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

  grunt.registerTask 'resources', 'Write resources to gsp template', (env) ->
    app = grunt.config.get('app')
    vendor = grunt.config.get('vendor')

    if env is 'debug'
      js = grunt.file.expand(vendor.js).concat grunt.file.expand(app.js.debug)
      css = grunt.file.expand(vendor.css.debug).concat grunt.file.expand(app.css.debug)
      dir = debugDir
    else
      js = grunt.file.expand(app.js.release)
      css = grunt.file.expand(vendor.css.release).concat grunt.file.expand(app.css.release)
      dir = releaseDir

    scriptTags = js.map (file) ->
      """<script type="text/javascript" src="${resource(file: '#{file.replace 'web-app/', ''}', plugin: 'console')}" ></script>"""

    linkTags = css.map (file) ->
      """<link rel="stylesheet" media="screen" href="${resource(file: '#{file.replace 'web-app/', ''}', plugin: 'console')}" />"""
      
    favicon = """<link rel="icon" type="image/png" href="${resource(file: '#{dir.replace 'web-app/', ''}/img/grails.logo.png', plugin: 'console')}" />"""

    grunt.file.write 'grails-app/views/console/_js.gsp', scriptTags.join '\n'
    grunt.file.write 'grails-app/views/console/_css.gsp', linkTags.join '\n'
    grunt.file.write 'grails-app/views/console/_favicon.gsp', favicon

  grunt.registerTask 'default', ['debug']
  grunt.registerTask 'test', ['debug', 'clean:spec', 'coffee:spec', 'jasmine']
  grunt.registerTask 'debug', ['clean:dist', 'handlebars:compile', 'coffee:app', 'copy:debug', 'less:app', 'resources:debug']
  grunt.registerTask 'release', ['debug', 'copy:release', 'concat:js', 'resources:release', 'clean:debug']
