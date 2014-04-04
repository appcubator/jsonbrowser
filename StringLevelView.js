// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var LevelView, StringLevelView, util;
    util = require('util');
    LevelView = require('cs!LevelView');
    return StringLevelView = (function(_super) {
      __extends(StringLevelView, _super);

      function StringLevelView() {
        return StringLevelView.__super__.constructor.apply(this, arguments);
      }

      StringLevelView.prototype.render = function() {
        var titleEl;
        manager.highlightPrevKey(this.level, this.title);
        this.domEl = document.createElement('div');
        this.domEl.className = "level editor";
        titleEl = document.createElement('div');
        titleEl.innerHTML = this.title;
        titleEl.className = "title";
        this.domEl.appendChild(titleEl);
        this.editor = document.createElement('div');
        this.editor.className = "text-editor";
        this.editor.id = "textEditor";
        this.domEl.appendChild(this.editor);
        document.body.appendChild(this.domEl);
        this.editor = ace.edit("textEditor");
        this.editor.setValue(this.parentObj[this.title]);
        return this.editor.getSession().on('change', function(e) {
          var val;
          val = this.editor.getValue();
          return this.parentObj[this.title] = val;
        });
      };

      return StringLevelView;

    })(LevelView);
  });

}).call(this);
