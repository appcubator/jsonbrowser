define (require, exports, module) ->

	util = require 'util'
	LevelView = require('cs!LevelView')

	class ObjectLevelView extends LevelView

		setKeys: () ->
			@keys = (ind for val, ind in @curObj)

