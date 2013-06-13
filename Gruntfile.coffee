
module.exports = (grunt) ->

  grunt.initConfig
    pkg: 
      grunt.file.readJSON('package.json')

    clean:
      default:  ["build/**/*"]

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
          { src: [ 'components/lodash/dist/lodash.mobile.js' ], dest: 'build/js/lodash.js' }
          { src: [ 'components/backbone/backbone-min.js' ], dest: 'build/js/backbone.js' }
          { src: [ 'components/jquery/jquery.min.js' ], dest: 'build/js/jquery.js' }
          { src: [ 'components/jquery-serialize-object/jquery.serialize-object.compiled.js' ], dest: 'build/js/jquery.serialize-object.js' }
          { src: [ 'components/snapjs/snap.min.js' ], dest: 'build/js/snap.js' }
          { src: [ 'components/blockui/jquery.blockUI.js' ], dest: 'build/js/jquery.blockUI.js' }
        ]
      default:
        files: [
          { expand: true, cwd: 'src/static/', src: [ '**/*' ], dest: 'build/'}
        ]

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
    
    uglify: 
      components: 
        files:
          'build/js/jquery.blockUI.js': ['components/blockui/jquery.blockUI.js']
          'build/js/lodash.js': ['components/lodash/dist/lodash.mobile.js']
      default: 
        files:
          'build/js/templates.js': ['build/js/templates.js']
          'build/js/prayercloud.js': ['build/js/prayercloud.js']
        

  grunt.loadNpmTasks('grunt-contrib-jst')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-uglify')
