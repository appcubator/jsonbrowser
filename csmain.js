// Generated by CoffeeScript 1.7.1
(function() {
  define(['underscore', 'jquery', 'ace', './LevelView', './StringLevelView', './ObjectLevelView', './ArrayLevelView', 'util', './test-json'], function(_, $, ace, LevelView, StringLevelView, ObjectLevelView, ArrayLevelView, util) {
    var Manager;
    Manager = function() {
      var bindNavigationKey, fillEditor, getLastKey, levels, navigateToArray, navigateToNumberEditor, navigateToObject, navigateToStringEditor;
      levels = {};
      this.setupEditor = function(rootObj) {
        var firstView, keys;
        this.rootJson = rootObj;
        keys = _.keys(json);
        firstView = new ObjectLevelView("ROOT", json, null, null, 0);
        levels[0] = firstView;
        firstView.superView = this;
        return firstView.render();
      };
      this.navigateToKeyFromEl = function(e) {
        var el, key, level, parentPath;
        el = e.currentTarget;
        parentPath = el.dataset.parentPath;
        key = el.dataset.key;
        level = el.dataset.level;
        return this.navigateToKey(key, parentPath, level);
      };
      this.navigateToKey = function(key, parentPath, level) {
        var nextLevel, obj, parentObj;
        parentObj = manager.getObjWithPath(parentPath);
        obj = parentObj[key];
        level = parseInt(level);
        nextLevel = level + 1;
        this.cleanDeeperLevels(nextLevel);
        switch (util.getType(obj)) {
          case "object":
            return navigateToObject(obj, parentObj, key, parentPath, nextLevel);
          case "string":
            return navigateToStringEditor(obj, parentObj, key, parentPath, nextLevel);
          case "array":
            return navigateToArray(obj, parentObj, key, parentPath, nextLevel);
          case "number":
            return navigateToNumberEditor(obj, parentObj, key, parentObj, parentPath, nextLevel);
        }
      };
      this.cleanDeeperLevels = function(levelNo) {
        var curLevel, _results;
        curLevel = levels[levelNo];
        _results = [];
        while (curLevel) {
          curLevel.remove();
          curLevel = null;
          levelNo++;
          _results.push(curLevel = levels[levelNo]);
        }
        return _results;
      };
      this.getObjWithPath = function(path) {
        var curObj, token, tokens, _i, _len;
        tokens = path.split('.');
        if (tokens.length === 0 || path === null || path === "null" || path === "ROOT" || path === "undefined") {
          return this.rootJson;
        } else {
          curObj = json;
          for (_i = 0, _len = tokens.length; _i < _len; _i++) {
            token = tokens[_i];
            curObj = curObj[token];
          }
          return curObj;
        }
      };
      this.highlightPrevKey = function(level, title) {
        var levelObj;
        level = level - 1;
        levelObj = levels[level];
        if (title !== null && levelObj) {
          return levelObj.highlightKey(title);
        }
      };
      getLastKey = function(path) {
        var tokens;
        if (!path) {
          null;
        }
        tokens = path.split('.');
        return tokens[tokens.length - 1];
      };
      fillEditor = function(string, key, newParentPath) {
        $(levelEditor).css('display', 'inline-block');
        return editor.setValue(string);
      };
      navigateToStringEditor = function(obj, parentObj, title, parentPath, nextLevel) {
        var firstView;
        firstView = new StringLevelView(title, obj, parentObj, parentPath, nextLevel);
        firstView.render();
        return levels[nextLevel] = firstView;
      };
      navigateToNumberEditor = function(obj, parentObj, title, parentPath, nextLevel) {
        var e, newValue;
        newValue = prompt("Please enter the new Value", obj);
        try {
          return parentObj[title] = parseInt(newValue);
        } catch (_error) {
          e = _error;
          return parentObj[title] = newValue;
        }
      };
      navigateToObject = function(obj, parentObj, title, parentPath, nextLevel) {
        var firstView;
        firstView = new ObjectLevelView(title, obj, parentObj, parentPath, nextLevel);
        firstView.superView = this;
        firstView.render();
        return levels[nextLevel] = firstView;
      };
      navigateToArray = function(obj, parentObj, title, parentPath, nextLevel) {
        var firstView;
        firstView = new ArrayLevelView(title, obj, parentObj, parentPath, nextLevel);
        firstView.superView = this;
        firstView.render();
        return levels[nextLevel] = firstView;
      };
      bindNavigationKey = function(domEl) {
        return $(domEl).on('click', navigateToKey);
      };
      return this;
    };
    window.manager = new Manager();
    return manager.setupEditor(json);
  });

}).call(this);
