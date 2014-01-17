'use strict';

module.exports = function (grunt) {
  // load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  grunt.initConfig({
    watch: {
      coffee: {
        files: ['lib/{,*/}*.coffee'],
        tasks: ['coffee:dist']
      },
      coffeeTest: {
        files: ['test/spec/{,*/}*.coffee'],
        tasks: ['test']
      },
    },
    connect: {
      options: {
        port: 9000,
        // Change this to '0.0.0.0' to access the server from outside.
        hostname: 'localhost'
      },
    },
    open: {
      server: {
        url: 'http://localhost:<%= connect.options.port %>'
      }
    },
    clean: {
      server: 'tmp'
    },
    coffee: {
      options: {bare: true},
      dist: {
        files: [{
          expand: true,
          cwd: 'lib',
          src: '{,*/}*.coffee',
          dest: 'tmp',
          ext: '.js'
        }]
      }
    },
    coffeelint: {
      app: ['{,*/}*.coffee']
    },
    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: ['coffee-script'],
        },
        src: ['test/**/*.coffee']
      }
    }
  });

  grunt.registerTask('server', [
    'clean:server',
    'connect',
    'open',
    'watch'
  ]);

  grunt.registerTask('test', ['coffeelint', 'mochaTest']);

  grunt.registerTask('default', ['server']);
};