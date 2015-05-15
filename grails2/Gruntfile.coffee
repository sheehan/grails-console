module.exports = (grunt) ->

  debugDir = "web-app/dist/debug"
  releaseDir = "web-app/dist/release"
  vendorDir = "web-app/vendor"
  webSrcDir = '../web'
  targetDir = 'web-app/target'

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
      js: [
        "#{vendorDir}/js/libs/jquery-1.7.1.min.js"
        "#{vendorDir}/jquery-ui-1.10.3/jquery-ui.min.js"
        "#{vendorDir}/bootstrap/js/bootstrap.min.js"
        "#{vendorDir}/js/libs/underscore-min.js"
        "#{vendorDir}/js/libs/backbone-min.js"
        "#{vendorDir}/js/libs/backbone.marionette.min.js"
        "#{vendorDir}/js/libs/handlebars.runtime-v3.0.1.js"
        "#{vendorDir}/jquery-layout/js/jquery.layout-latest.min.js"
        "#{vendorDir}/js/plugins/jquery.hotkeys.js"
        "#{vendorDir}/codemirror-5.2/lib/codemirror.js"
        "#{vendorDir}/codemirror-5.2/mode/groovy/groovy.js"
      ]
      css: [
        "#{vendorDir}/bootstrap/css/bootstrap.min.css"
        "#{vendorDir}/font-awesome-4.0.3/css/font-awesome.css"
        "#{vendorDir}/codemirror-5.2/lib/codemirror.css"
        "#{vendorDir}/codemirror-5.2/theme/lesser-dark.css"
        "#{vendorDir}/jquery-layout/css/jquery.layout.css"
        "#{vendorDir}/jquery-ui-1.10.3/jquery-ui.min.css"
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
          vendor: ['<%= vendor.js %>', "#{vendorDir}/js/plugins/jasmine-jquery.js"]

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
      vendor:
        expand: true,
        cwd: "#{webSrcDir}/vendor"
        src: '**/*'
        dest: vendorDir
      debug:
        expand: true,
        cwd: 'web-app/src/img'
        src: '**/*'
        dest: "#{debugDir}/img"
      release:
        files: [
          { expand: true, cwd: "#{webSrcDir}/img", src: '**/*', dest: "#{releaseDir}/img" }
          { expand: true, cwd: "#{vendorDir}", src: '**/*', dest: "#{releaseDir}/vendor" }
          { src: "#{debugDir}/app.css", dest: '<%= app.css.release %>' }
        ]

    clean:
      dist: ['web-app/dist']
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
      css = grunt.file.expand(vendor.css).concat grunt.file.expand(app.css.debug)
    else
      js = grunt.file.expand(app.js.release)
      css = grunt.file.expand(vendor.css).concat grunt.file.expand(app.css.release)

    scriptTags = js.map (file) ->
      """<script type="text/javascript" src="${resource(file: '#{file.replace 'web-app/', ''}', plugin: 'console')}" ></script>"""

    linkTags = css.map (file) ->
      """<link rel="stylesheet" media="screen" href="${resource(file: '#{file.replace 'web-app/', ''}', plugin: 'console')}" />"""

    grunt.file.write 'grails-app/views/console/_js.gsp', scriptTags.join '\n'
    grunt.file.write 'grails-app/views/console/_css.gsp', linkTags.join '\n'

  grunt.registerTask 'default', ['debug']
  grunt.registerTask 'test', ['debug', 'clean:spec', 'coffee:spec', 'jasmine']
  grunt.registerTask 'debug', ['clean:dist', 'handlebars:compile', 'coffee:app', 'copy:debug', 'copy:vendor', 'less:app', 'resources:debug']
  grunt.registerTask 'release', ['debug', 'copy:release', 'concat:js', 'resources:release']