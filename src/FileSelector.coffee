util = require './util'

class FileSelector

	constructor: () ->
		@files = []
		@currentLevel = null
		@clipboardFiles = [];


	getIndexOfKey: (targetKey) ->
		for key, index in @currentLevel.keys
			if key == targetKey
				return index

		return 0

	elementClicked: (key, level) ->
		@currentLevel = level
		@files = [key]


	elementShiftClicked: (key, level)->
		if level != @currentLevel
			@currentLevel = level
			ind = @getIndexOfKey(key)
			@selectRange(0, ind)
		else
			startInd = @getIndexOfKey(@files[0])
			ind = @getIndexOfKey(key)
			@selectRange(startInd, ind)

		# clear deeper levels here


	selectRange: (start, end)->
		if start > end
			[start, end] = [end, start]


		@files = []
		for i in [start...end+1] by 1
			key = @currentLevel.keys[i]
			@files.push(key)

		@currentLevel.highlightKeys(@files)

		for key in @files
			liView = @currentLevel.getLiView(key)
			@makeDraggable(liView)

		for key in _.difference(@currentLevel.keys, @files)
			@makeDroppable(@currentLevel.getLiView(key))


	getClonesExceptCurrent: (currentLiView)->

		$clones = []
		for key in @files
			liView = @currentLevel.getLiView(key)
			if liView != currentLiView
				$domEl = $(liView.domEl).clone()
				$domEl.addClass('ui-draggable-dragging');
				$clones.push($domEl)
				# adding the margins depending on the distance
				# of the clone from the element that is being draggeed
				p1 = $(liView.domEl).offset();
				p2 = $(currentLiView.domEl).offset();
				$domEl.css({
					marginLeft: p1.left - p2.left,
					marginTop: p1.top - p2.top
				});

		return $clones


	makeDraggable: (liView)->

		domEl = liView.domEl
		$clones = @getClonesExceptCurrent(liView)
		currentLevel = @currentLevel

		$(domEl).draggable {

			helper: "clone"

			start: (e, ui) ->
				#if e.target.id == "start"
				_.each $clones, ($clone) ->
					$(currentLevel.domEl).append($clone)

			
			stop: (e, ui) ->
				# remove the clone elements
				_.each $clones, ($clone) ->
					$clone.remove()
			
			drag: (e, ui) -> 
				#if e.target.id == "start"
					# this works because the position is relative to the starting position
				_.each $clones, ($clone) ->
					$clone.css({
						position: "absolute",
						top: ui.position.top,
						left: ui.position.left
					});
				
				# debug = () -> 
				# 	debugger;

				# setTimeout debug, 3000


		}

	makeDroppable: (liView) ->
		elementsDroppedTo = @elementsDroppedTo
		$(liView.domEl).droppable {
			drop: (e, ui) ->
				elementsDroppedTo(liView)
			over: (e, ui ) ->
				$(e.target).addClass('droppable');
			out: (e, ui) ->
				$(e.target).removeClass('droppable');
		}


	elementsDroppedTo: (liView) =>

		if util.getType(@currentLevel.curObj) == "object"
			obj = liView.getObj()
			for key in @files
				obj[key] = @currentLevel.curObj[key]
				delete @currentLevel.curObj[key]

		@currentLevel.render(true)


	copy: () ->
		@clipboardFiles = {}
		for key in @files
			@clipboardFiles[key] = @currentLevel.curObj[key]


	paste: () ->
		for key, value of @clipboardFiles
			@superView.activeLevel.addKeyValue(key, value)


exports.FileSelector = FileSelector