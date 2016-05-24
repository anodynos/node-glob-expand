module.exports = (grunt) ->
  gruntConfig =
    urequire:
      _all:
        clean: true
        template:
          name: 'nodejs'
          banner: true
        bare: true
        runtimeInfo: false

      build:
        path: 'source/code'
        dstPath: 'build/code'
        resources: [ 'inject-version' ]

  grunt.registerTask default: ['urequire:build']
  require('load-grunt-tasks')(grunt)
  grunt.initConfig gruntConfig
