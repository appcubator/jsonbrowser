// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var LevelView, ListElementView, util;
    util = require('util');
    ListElementView = require('./ListElementView');
    LevelView = (function() {
      var liViews;

      liViews = {};

      function LevelView(keys, title, curObj, parentObj, parentPath, level) {
        this.keys = keys;
        this.title = title;
        this.curObj = curObj;
        this.parentObj = parentObj;
        this.parentPath = parentPath;
        this.level = level;
        if (util.isRootPath(this.parentPath)) {
          this.currentPath = title;
        } else {
          this.currentPath = parentPath + "." + title;
        }
        this.level = level || 0;
      }

      LevelView.prototype.render = function() {
        var key, levelEl, liEl, liView, _i, _len, _ref;
        manager.highlightPrevKey(this.level, this.title);
        levelEl = document.createElement('ul');
        levelEl.className = "level one";
        liEl = document.createElement('li');
        liEl.className = 'title';
        liEl.innerHTML = this.title;
        levelEl.appendChild(liEl);
        _ref = this.keys || [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          key = _ref[_i];
          liView = new ListElementView(this.currentPath, key, this.curObj, this.level);
          liViews[key] = liView;
          liEl = liView.render();
          levelEl.appendChld(liEl);
        }
        document.body.appendChild(levelEl);
        return this.domEl = levelEl;
      };

      LevelView.prototype.highlightKey = function(keyToSelect) {
        var key, newSelectedLiView, val;
        for (key in liViews) {
          val = liViews[key];
          val.disableEditKeyMode();
        }
        if (this.selectedLiView) {
          this.selectedLiView.unhighlight();
        }
        newSelectedLiView = liViews[keyToSelect];
        newSelectedLiView.highlight();
        return this.selectedLiView = newSelectedLiView;
      };

      LevelView.prototype.remove = function() {
        return $(this.domEl).remove();
      };

      return LevelView;

    })();
    return LevelView;
  });

}).call(this);