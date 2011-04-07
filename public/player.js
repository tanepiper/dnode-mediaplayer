(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  window.Player = (function() {
    __extends(Player, process.EventEmitter);
    function Player(player_elem, canvas_elem, playlist) {
      this.image = playlist.image ? playlist.image || null : void 0;
      this.audio_files = playlist.audio_files;
      this.player = jQuery(player_elem).jPlayer({
        swfPath: "/jplayer",
        supplied: "oga",
        ready: function() {
          return $(this).jPlayer('setMedia', {
            oga: playlist.audio_files[0].path
          });
        }
      });
      this.canvas = jQuery(canvas_elem).get()[0];
      this.c_context = this.canvas.getContext('2d');
    }
    Player.prototype.playerWidget = function() {
      return "<div class=\"jp-audio\">\n    <div class=\"jp-type-single\">\n        <div class=\"jp-interface\">\n            <ul class=\"jp-controls\">\n                <li><a href=\"#\" class=\"jp-play\" tabindex=\"1\">Play</a></li>\n                <li><a href=\"#\" class=\"jp-pause\" tabindex=\"2\">Pause</a></li>\n                <li><a href=\"#\" class=\"jp-stop\" tabindex=\"3\">Stop</a></li>\n                <li><a href=\"#\" class=\"jp-previous\" tabindex=\"4\">Prev</a></li>\n                <li><a href=\"#\" class=\"jp-next\" tabindex=\"5\">Next</a></li>\n                <li><a href=\"#\" class=\"jp-mute\" tabindex=\"6\">Mute</a></li>\n                <li><a href=\"#\" class=\"jp-unmute\" tabindex=\"7\">Unmute</a></li>\n            </ul>\n            <div class=\"jp-progress\">\n                <div class=\"jp-seek-bar\">\n                    <div  class=\"jp-play-bar\"></div>\n                </div>\n            </div>\n    \n            <div class=\"jp-volume-bar\">\n                <div class=\"jp-volume-bar-value\"></div>\n            </div>\n            <div class=\"jp-current-time\"></div>\n            <div class=\"jp-duration\"></div>\n        </div>\n        <div id=\"playlist\" class=\"jp-playlist\">\n            <ul></ul>\n        </div>\n    </div>\n</div>";
    };
    Player.prototype.init = function() {
      var file, item, link, _i, _len, _ref;
      _ref = this.audio_files;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        file = _ref[_i];
        link = $("<a id=\"" + file.index + "\" href=\"" + file.path + "\">" + file.name + "</a>");
        this.attachHandler(link);
        item = $('<li></li>').append(link);
        jQuery('.jp-playlist ul').append(item);
      }
      return this.player.jPlayer('setMedia', {
        oga: this.audio_files[0].path
      });
    };
    Player.prototype.attachHandler = function(link) {
      var id;
      id = parseInt(link.attr('id'), 10);
      return link.click(__bind(function() {
        console.log(id);
        this.player.jPlayer('setMedia', {
          oga: this.audio_files[id].path
        });
        this.player.jPlayer('play');
        return false;
      }, this));
    };
    return Player;
  })();
}).call(this);
