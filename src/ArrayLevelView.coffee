define (require, exports, module) ->

	util = require 'util'
	LevelView = require('cs!LevelView')

	class ObjectLevelView extends LevelView

		setKeys: () ->
			@keys = (ind for val, ind in @curObj)

		sorted: () ->
			arr = $(@domEl).sortable('toArray', {attribute: 'data-key'});
			newArr = []
			for ind in arr
				if ind != ""
					nmrInd = parseInt(ind)
					newArr.push(@curObj[nmrInd])

			@parentObj[@title] = newArr
			@render(true)