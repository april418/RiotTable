module.exports = (config) ->
  config.set
    # Enable or disable watching files and executing the tests whenever one of these files changes.
    autoWatch: true

    # The root path location that will be used to resolve all relative paths defined in files and exclude.
    # If the basePath configuration is a relative path,
    # then it will be resolved to the __dirname of the configuration file.
    #basePath: ''

    # A list of browsers to launch and capture.
    # When Karma starts up, it will also start up each browser which is placed within this setting.
    # Once Karma is shut down, it will shut down these browsers as well.
    # You can capture any browser manually by opening the browser and visiting the URL
    # where the Karma web server is listening (by default it is http://localhost:9876/).
    #
    # - Chrome (launcher requires karma-chrome-launcher plugin)
    # - ChromeCanary (launcher requires karma-chrome-launcher plugin)
    # - PhantomJS (launcher requires karma-phantomjs-launcher plugin)
    # - Firefox (launcher requires karma-firefox-launcher plugin)
    # - Opera (launcher requires karma-opera-launcher plugin)
    # - IE (launcher requires karma-ie-launcher plugin)
    # - Safari (launcher requires karma-safari-launcher plugin)
    browsers: [
      'PhantomJS'
    ]

    # If browser does not capture in given timeout [ms], kill it
    #captureTimeout: 60000

    # Enable or disable colors in the output (reporters and logs).
    colors: true

    # coffee-secript preprocessor config
    coffeePreprocessor:
      options:
        bare: true
        sourceMap: true

    # List of files/patterns to load in the browser.
    files: [
      'node_modules/phantomjs-polyfill-object-assign/object-assign-polyfill.js'
      'spec/**/*-spec.coffee'
    ]

    # List of test frameworks you want to use.
    # Typically, you will set this to ['jasmine'], ['mocha'] or ['qunit']...
    # Please note just about all frameworks in Karma require an additional plugin/framework library to be installed (via NPM).
    # Additional information can be found in plugins.
    frameworks: [
      'mocha'
      'chai'
      'browserify'
      'riot'
    ]

    # Hostname to be used when capturing browsers.
    #hostname: 'localhost'

    # List of files/patterns to exclude from loaded files.
    #exclude: []

    # Level of logging.
    #
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO

    # List of plugins to load.
    # A plugin can be a string (in which case it will be required by Karma) or an inlined plugin - Object.
    # By default, Karma loads all sibling NPM modules which have a name starting with karma-*.
    plugins: [
      'karma-mocha'
      'karma-mocha-reporter'
      'karma-nyan-reporter'
      'karma-chai'
      'karma-coffee-preprocessor'
      'karma-phantomjs-launcher'
      'karma-riot'
      'karma-browserify'
    ]

    # The port where the web server will be listening.
    port: 8080

    # A map of preprocessors to use.
    # Preprocessors can be loaded through plugins.
    preprocessors:
      'spec/**/*-spec.coffee': [
        'browserify'
      ]

    # A list of reporters to use.
    # Additional reporters, such as growl, junit, teamcity or coverage can be loaded through plugins.
    reporters: [
      #'mocha'
      'nyan'
    ]

    # RIOT preprocessor config
    riotPreprocessor:
      options:
        type: 'coffeescript'
        expr: true
        template: 'pug'
        style: 'sass'


    # Continuous Integration mode.
    # If true, Karma will start and capture all configured browsers,
    # run tests and then exit with an exit code of 0 or 1 depending on whether all tests passed or any tests failed.
    singleRun: false

