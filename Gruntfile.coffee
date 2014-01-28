module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  grunt.initConfig
    watch:
      coffee:
        files: ["lib/{,*/}*.coffee"]
        options: { nospawn: true }
        tasks: ["coffee:target", "develop"]

      coffeeTest:
        files: ["test/spec/{,*/}*.coffee"]
        tasks: ["test"]

    connect:
      options:
        port: 9000

        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "localhost"

    develop:
      server:
        file: 'main.js'
        cmd: 'node'
        nodeArgs: ['--debug']
        env:
          NODE_ENV: 'devel'
          PORT: 3000

    clean:
      server: "target"

    coffee:
      options:
        bare: true

      target:
        files: [
          expand: true
          cwd: "lib"
          src: "{,*/}*.coffee"
          dest: "target"
          ext: ".js"
        ]

    coffeelint:
      app: ["{,*/}*.coffee"]

    mochaTest:
      test:
        options:
          reporter: "spec"
          require: ["coffee-script"]

        src: ["test/**/*.coffee"]


  grunt.registerTask "run", ["clean", "coffee", "develop", "watch"]
  grunt.registerTask "test", ["coffeelint", "mochaTest"]
  grunt.registerTask "build", ["clean", "coffee"]
  grunt.registerTask "default", ["devserver"]
