{util} = require './util'
{LevelView} = require './LevelView'

class ArrayLevelView extends LevelView

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


exports.ArrayLevelView = ArrayLevelView