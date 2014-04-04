define (require, exports, module) ->

	util = require 'util'
	ListElementView = require './ListElementView'

	class LevelView 

		liViews = {}

		constructor: (@keys, @title, @curObj, @parentObj, @parentPath, @level) ->
			
			if util.isRootPath @parentPath
				@currentPath = title
			else
				@currentPath = parentPath + "."  + title

			@level = level || 0;


		render: () ->
			manager.highlightPrevKey(@level, @title);

			levelEl = document.createElement('ul');
			levelEl.className = "level one";

			liEl = document.createElement('li');
			liEl.className = 'title';
			liEl.innerHTML = this.title;
			levelEl.appendChild(liEl);

			for key in @keys || []
				liView = new ListElementView @currentPath, key, @curObj, @level
				liViews[key] = liView
				liEl = liView.render()
				levelEl.appendChld(liEl);

			document.body.appendChild(levelEl);
			@domEl = levelEl;


		highlightKey: (keyToSelect) ->

			for key,val of liViews
				val.disableEditKeyMode()

			if @selectedLiView
				@selectedLiView.unhighlight()

			newSelectedLiView = liViews[keyToSelect]
			newSelectedLiView.highlight()
			@selectedLiView = newSelectedLiView

		remove: () ->
			$(@domEl).remove()

	return LevelView

