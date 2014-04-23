{FileSelector} = require './FileSelector'
{ObjectLevelView} = require './ObjectLevelView'
{ArrayLevelView} = require './ArrayLevelView'
{StringLevelView} = require './StringLevelView'
{util} = require './util'

# this is the class that controls the overall functionality
class Manager
	
	# every value field is represented as a "level"
	# this is the dictionary that keeps track of the 
	# level views. {levelNo : levelView}
	constructor: () ->
		@levels = {};
		@activeLevel = null
		@selector = new FileSelector()
		@isShiftPressed = false

	# setup function that takes in the json that
	# will be browsed
	setupEditor: (rootObj) ->

		@rootJson = rootObj;

		firstView = new ObjectLevelView "ROOT", @rootJson, null, null, 0;
		@levels[0] = firstView;
		@activeLevel = @levels[0]

		firstView.superView = this;
		firstView.render();

		$(document).bind 'keydown', (e) => 
			@isShiftPressed = e.shiftKey
			cntrled = e.metaKey || e.ctrlKey

			switch e.keyCode
				when 37
					console.log("hey")
				when 38
					@activeLevel.navigateUp()
				when 39
					console.log("hey")
				when 40
					@activeLevel.navigateDown()

			return true


		$(document).on 'keyup', (e) =>
			@isShiftPressed = e.shiftKey
			return true

	# gets called when a list element is
	# clicked
	selectKeyFromEl: (e) ->

		el = e.currentTarget;
		parentPath = el.dataset.parentPath;
		key = el.dataset.key;
		level = el.dataset.level;

		if @isShiftPressed is true
			@selector.elementShiftClicked(key, @levels[level])
		else
			@selector.elementClicked(key, @levels[level])
			@navigateToKey(key, parentPath, level)


	navigateToKey: (key, parentPath, level) ->
		parentObj = @getObjWithPath(parentPath);

		obj = parentObj[key];
		level = parseInt(level);
		nextLevel = level + 1;
		@cleanDeeperLevels(nextLevel);

		switch util.getType(obj)
			when "object"
				@navigateToObject(obj, parentObj, key, parentPath, nextLevel);
			when "string"
				@navigateToStringEditor(obj, parentObj, key, parentPath, nextLevel);
			when "array"
				@navigateToArray(obj, parentObj, key, parentPath, nextLevel);
			when "number"
				@navigateToNumberEditor(obj, parentObj, key, parentObj, parentPath, nextLevel);


	rerenderLevel: (level) ->
		@levels[level].render(true)

	getLevelViews: () ->
		@levels

	# removes the views after the given level
	cleanDeeperLevels: (levelNo) ->
		curLevel = @levels[levelNo];

		while (curLevel)
			curLevel.remove() 
			curLevel = null 
			levelNo++;
			curLevel = @levels[levelNo];


	# returns the object give a path
	getObjWithPath: (path) ->
		if path == null
			return @rootJson

		tokens = path.split('.');
		
		if tokens.length == 0 || path == null || path == "null" || path == "ROOT" || path == "undefined"
			#return
			@rootJson;
		else
			curObj = @rootJson;
			for token in tokens
				curObj = curObj[token]
			#return
			curObj

	# highlights the list element give the 
	# title/key and the level
	highlightPrevKey: (level, title) ->
		level = level - 1;
		levelObj = @levels[level];
		if title != null and levelObj
			levelObj.highlightKey(title);
	

	getLastKey: (path) ->          
		if (!path)
			null;

		tokens = path.split('.');
		return tokens[tokens.length - 1];



	fillEditor: (string, key, newParentPath) ->
		$(levelEditor).css('display', 'inline-block');
		editor.setValue(string);


	navigateToStringEditor: (obj, parentObj, title, parentPath, nextLevel) ->

		firstView = new StringLevelView title, obj, parentObj, parentPath, nextLevel;
		firstView.superView = this;
		firstView.render();

		@levels[nextLevel] = firstView;


	navigateToNumberEditor: (obj, parentObj, title, parentPath, nextLevel) ->

		newValue = prompt("Please enter the new Value", obj);
		
		try parentObj[title] = parseInt(newValue)
		catch e then parentObj[title] = newValue

	navigateToObject: (obj, parentObj, title, parentPath, nextLevel) ->

		firstView = new ObjectLevelView title, obj, parentObj, parentPath, nextLevel;
		firstView.superView = this;
		firstView.render();

		@levels[nextLevel] = firstView;


	navigateToArray: (obj, parentObj, title, parentPath, nextLevel) ->
		
		firstView = new ArrayLevelView title, obj, parentObj, parentPath, nextLevel;
		firstView.superView = this;
		firstView.render();

		@levels[nextLevel] = firstView;


	bindNavigationKey: (domEl) ->
		$(domEl).on('click', @navigateToKey);


	activateLevel: (level) ->
		@levels[level]


exports.Manager = Manager