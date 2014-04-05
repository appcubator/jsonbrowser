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
				levelEl.appendChild(liEl);

			liEl = document.createElement('li');
			liEl.className = 'add-more';
			liEl.innerHTML = '<div>+ Add Value</div>';
			levelEl.appendChild(liEl);

			document.body.appendChild(levelEl);

			@domEl = levelEl;
			$(@domEl).find('.add-more').one 'click' , @clickedAddMore

			@domEl

		rerender: () ->

			@keys = _.keys(@curObj);			

			@domEl.innerHTML = ''
			liEl = document.createElement('li');
			liEl.className = 'title';
			liEl.innerHTML = this.title;
			@domEl.appendChild(liEl);

			for key in @keys || []
				liView = new ListElementView @currentPath, key, @curObj, @level
				liViews[key] = liView
				liEl = liView.render()
				@domEl.appendChild(liEl);

			liEl = document.createElement('li');
			liEl.className = 'add-more';
			liEl.innerHTML = '<div>+ Add Value</div>';
			@domEl.appendChild(liEl);

			$(@domEl).find('.add-more').one 'click' , @clickedAddMore

			@domEl


		clickedAddMore: () =>
			str = ["<div class='object add-new'><span class='icon object'></span>Object</div>",
				   "<div class='array add-new'><span class='icon array'></span>Array</div>",
				   "<div class='string add-new'><span class='icon string'></span>String</div>",
				   "<div class='number add-new'><span class='icon number'></span>Number</div>"].join('\n')

			$(@domEl).find('.add-more').html(str)
			$(@domEl).find('.add-new').one 'click', @clickedAddNew


		clickedAddNew: (e) =>

			className = e.currentTarget.className
			className = className.replace(' add-new', '');
			@showKeyInput(className)


		showKeyInput: (type) ->
			$(@domEl).find('.add-more').html "<form class='new-name-form'><input class='name-input' type='text'></input></form>"
			$(@domEl).find('.new-name-form').on 'submit', (e) => @newNameFormSubmitted(e, type)


		newNameFormSubmitted: (e, type) =>
			e.preventDefault()
			newName = $(@domEl).find('.name-input').val()
			@addNewValue(newName, type)


		addNewValue: (key, valueType)->

			switch valueType
				when "object"
					@curObj[key] = {}
				
				when "string"
					@curObj[key] = "default"
				
				when "array"
					@curObj[key] = ["1"]

				when "number"
					@curObj[key] = 0

			@rerender()

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

