// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var FileSelector, util;
    util = require('util');
    return FileSelector = (function() {
      function FileSelector() {
        this.files = [];
        this.currentLevel = null;
      }

      FileSelector.prototype.getIndexOfKey = function(targetKey) {
        var index, key, _i, _len, _ref;
        _ref = this.currentLevel.keys;
        for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
          key = _ref[index];
          if (key === targetKey) {
            return index;
          }
        }
        return 0;
      };

      FileSelector.prototype.elementClicked = function(key, level) {
        this.currentLevel = level;
        return this.files = [key];
      };

      FileSelector.prototype.elementShiftClicked = function(key, level) {
        var ind;
        if (level !== this.currentLevel) {
          this.currentLevel = level;
          ind = this.getIndexOfKey(key);
          return this.selectRange(0, ind);
        }
      };

      FileSelector.prototype.selectRange = function(start, end) {
        var i, _i, _ref;
        this.files = [];
        for (i = _i = start, _ref = end + 1; start <= _ref ? _i < _ref : _i > _ref; i = start <= _ref ? ++_i : --_i) {
          this.files.push(this.currentLevel.keys[i]);
        }
        return this.currentLevel.highlightKeys(this.files);
      };

      return FileSelector;

    })();
  });

}).call(this);
