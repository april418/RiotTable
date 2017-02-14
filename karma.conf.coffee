module.exports = (config) ->
  config.set
    basePath: ''
    frameworks: [
      'mocha'
      'chai'
      'riot'
      'browserify'
    ]
    plugins: [
      'karma-mocha'
      'karma-mocha-reporter'
      'karma-chai'
      'karma-coffee-preprocessor'
      'karma-phantomjs-launcher'
      'karma-riot'
      'karma-browserify'
    ]
    files: [
      'test/**/*-spec.coffee'
    ]
    preprocessors:
      'src/**/*.coffee': [
        'browserify'
      ]
      'src/**/*.tag': [
        'riot'
      ]
      'test/**/*.coffee': [
        'coffee'
      ]
    coffeePreprocessor:
      options:
        bare: true
        sourceMap: true
    browserify:
      debug: true
      transform: [
        [
          'riotify'
          {
            type: 'coffeescript'
            expr: true
            template: 'pug'
            style: 'sass'
          }
        ]
        'coffeeify'
      ]
      extensions: [
        '.tag'
        '.coffee'
      ]
    browsers: [
      'PhantomJS'
    ]
    reporters: [
      'mocha'
    ]
    singleRun: true
    port: 8080

