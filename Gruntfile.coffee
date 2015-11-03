module.exports = (grunt)->

  # Formats template names to be sexier.
  jadeTemplateId = (filepath)->
    filepath
    .replace(
      /^\app\/modules\/(.*)\/template.jade$/
      '$1'
    )
    .replace(
      /^app\/modules\/(.*)\/directives\/(.*).jade$/
      '$1/$2/widget'
    )
    .replace(
      /^app\/modules\/directives\/(.*).jade$/
      '$1/widget'
    )

  grunt.initConfig
    bower:
      dev:
        dest: "build/vendor"
    rename: # Angular needs to be loaded before dependant libs. Renaming helps to not include it twice.
      vendor_js:
        files: "build/angular.js": "build/vendor/angular.js"
    concat:
      vendor_js:
        files: "build/vendor.js": [
          "build/vendor/*.js"
        ]
      vendor_css:
        files: "build/vendor.css": ["build/vendor/*.css"]

    browserify:
      dev:
        src: ["app/index.js"]
        dest: "build/application.js"
    jade:
      index:
        files: "build/index.html": "app/index.jade"
    ngjade:
      templates:
        options:
          moduleName:"devup"
          processName:jadeTemplateId
        files:[{
          expand: false
          src: [
            "app/modules/**/template.jade"
            "app/modules/**/directives/*.jade"
          ]
          dest: "build/templates.js"
        }]
    less:
      dev:
        files:
          "build/application.css": ["app/index.less", "app/modules/**/*.less"]

    watch:
      scripts:
        files: [
          'Gruntfile.coffee' # Oh! How metta!
          'app/modules/**/*.jade'
          'app/modules/**/*.js'
          'app/modules/**/*.less'
          'app/index.less'
          'app/index.jade'
          'app/index.js'
        ]
        tasks: ["build"]
        options:
          reload: true
    notify_hooks:
      options:
        enabled: true
        success: true # whether successful grunt executions should be notified automatically
        duration: 3 # the duration of notification in seconds, for `notify-send only

  grunt.loadNpmTasks 'grunt-bower'
  grunt.loadNpmTasks 'grunt-rename'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-ngjade'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-notify'

  grunt.registerTask "build", [
    "bower:dev"
    "rename:vendor_js"
    "concat:vendor_js"
    "concat:vendor_css"
    "browserify:dev"
    "jade:index"
    "ngjade:templates"
    "less:dev"
    "notify_hooks"
  ]

  grunt.registerTask "default", ["build"]
  grunt.task.run 'notify_hooks'
