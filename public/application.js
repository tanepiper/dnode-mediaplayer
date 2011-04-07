(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  window.Application = (function() {
    __extends(Application, process.EventEmitter);
    function Application() {
      this.dnode = DNode({
        serverMessage: __bind(function(message) {
          return console.log(message);
        }, this)
      });
      this.dnode.connect(__bind(function(remote, connection) {
        this.remote = remote;
        return this.emit('connected', remote, connection);
      }, this));
      this._ = require('underscore');
      this.backbone = require('backbone');
    }
    Application.prototype.addSource = function(elem, path) {
      return $('<source>').attr('src', path).appendTo(elem);
    };
    return Application;
  })();
  window.app = new Application();
  app.on('connected', function(remote, connection) {
    return remote.getSongs(function(error, files) {
      if (error) {
        return console.log(error);
      } else {
        console.log(files);
        return $(document).ready(function() {
          var file, id, index, link, _results;
          $("#jquery_jplayer_1").jPlayer({
            ready: function() {
              return $(this).jPlayer("setMedia", {
                oga: files['01.ogg'].path
              }).jPlayer("play");
            },
            ended: function(event) {
              return $(this).jPlayer("play");
            },
            swfPath: "/jplayer",
            supplied: "oga"
          });
          _results = [];
          for (index in files) {
            file = files[index];
            id = index.split('.')[0];
            link = $("<li><a id=\"" + id + "\" href=\"" + file.path + "\">" + index + "</a></li>");
            $('#jp_playlist_1 ul').append(link);
            _results.push($('#jp_playlist_1 ul li #' + id).click(function() {
              $("#jquery_jplayer_1").jPlayer("setMedia", {
                oga: file.path
              }).jPlayer('play');
              return false;
            }));
          }
          return _results;
        });
      }
    });
  });
}).call(this);
