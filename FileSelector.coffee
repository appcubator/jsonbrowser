define (require, exports, module) ->

	util = require 'util'

	class FileSelector

		constructor: () ->
			@files = []
			@currentLevel = null


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


		selectRange: (start, end)->

			@files = []
			for i in [start...end+1]
				@files.push(@currentLevel.keys[i])

			@currentLevel.highlightKeys(@files)
