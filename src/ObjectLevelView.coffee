util = require 'util'
{LevelView} = require './LevelView'

class ObjectLevelView extends LevelView

	setKeys: () ->
		@keys = _.keys(@curObj)

exports.ObjectLevelView = ObjectLevelView