// Generated by CoffeeScript 1.12.3
(function() {
  var Server, http,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  http = require('http');

  Server = (function() {
    function Server(options) {
      var ref;
      if (options == null) {
        options = {};
      }
      this.onRequest = bind(this.onRequest, this);
      this.port = (ref = options.port) != null ? ref : 8080;
      this.router = options.router;
    }

    Server.prototype.onRequest = function(request, response) {
      var requestData;
      console.log("Request received.");
      requestData = '';
      request.setEncoding('utf-8');
      request.addListener('data', (function(_this) {
        return function(chunkedRequestData) {
          console.log('Received POST data chunk.');
          return requestData += chunkedRequestData;
        };
      })(this));
      return request.addListener('end', (function(_this) {
        return function() {
          console.log('Finished to receive POST data.');
          return _this.router.route(request, requestData, response);
        };
      })(this));
    };

    Server.prototype.start = function() {
      http.createServer(this.onRequest).listen(this.port);
      return console.log('Server running.');
    };

    return Server;

  })();

  module.exports = Server;

}).call(this);
