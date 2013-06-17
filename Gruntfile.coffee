
module.exports = (grunt) ->

  grunt.initConfig
    pkg: 
      grunt.file.readJSON('package.json')

    clean:
      build:  ["build"]
      components: ["components"]

    shell:
      components: 
        command: 'bower install'      

    jst:
      default:
        files:
          "build/js/templates.js": ["src/app/templates/**/*.html"]
       options:
        processName: (filename) -> filename.match(/templates\/(.*)\.html$/)[1]
        templateSettings:
          escape :      /\{\{\{([\s\S]+?)\}\}\}/g
          interpolate:  /\{\{([\s\S]+?)\}\}/g
          
    browserify:
      dev:
        src:'src/app/main.coffee'
        dest: 'build/js/prayercloud.js'
        options: 
          transform: ['coffeeify']
          debug: true
      prod: 
        src:'src/app/main.coffee'
        dest: 'build/js/prayercloud.js'
        options: 
          transform: ['coffeeify']

    sass:
      default:
        files:
          "build/css/prayercloud.css": "src/style/main.scss"
    
    copy:
      components:
        files: [
          # { src: [ 'components/lodash/dist/lodash.mobile.js' ], dest: 'src/static/js/lodash.js' }
          { src: [ 'components/backbone/backbone-min.js' ], dest: 'src/static/js/backbone.js' }
          { src: [ 'components/jquery/jquery.min.js' ], dest: 'src/static/js/jquery.js' }
          { src: [ 'components/jquery-serialize-object/jquery.serialize-object.compiled.js' ], dest: 'src/static/js/jquery.serialize-object.js' }
          { src: [ 'components/snapjs/snap.min.js' ], dest: 'src/static/js/snap.js' }
          # { src: [ 'components/blockui/jquery.blockUI.js' ], dest: 'src/static/js/jquery.blockUI.js' }
        ]
      default:
        files: [
          { expand: true, cwd: 'src/static/', src: [ '**/*' ], dest: 'build/'}
        ]

    uglify: 
      components: 
        files:
          'src/static/js/jquery.blockUI.js': ['components/blockui/jquery.blockUI.js']
          'src/static/js/lodash.js': ['components/lodash/dist/lodash.mobile.js']
      default: 
        files:
          'build/js/templates.js': ['build/js/templates.js']
          'build/js/prayercloud.js': ['build/js/prayercloud.js']

    watch:
      templates:
        files: ["src/app/templates/**/*.html"]
        tasks: ["jst"]
        options: { nospawn: true }   
      styles:
        files: ["src/style/**/*.scss", "src/style/**/*.css"]
        tasks: ["sass"]
        options: { nospawn: true }
      backbone:
        files: ["src/app/**/*.coffee", "src/app/**/*.js"]
        tasks: ["browserify:dev"]
        options: { nospawn: true }
      static:
        files: ["src/static/**/*"]
        tasks: ["copy:default"]
        options: { nospawn: true }
            

  grunt.loadNpmTasks('grunt-contrib-jst')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-shell');

  grunt.registerTask('components', ['clean:components', 'shell:components', 'copy:components', 'uglify:components'])
  grunt.registerTask('default', ['clean:build', 'copy:default', 'sass', 'jst', 'browserify:dev' ])
  grunt.registerTask('prod', ['clean:build', 'copy:default', 'sass', 'jst', 'browserify:prod', 'uglify:default'])
