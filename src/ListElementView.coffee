define (require, exports, module) ->

	util = require 'util'

	class ListElementView 

		@type = ""
		@enableMode = false;
		@isShiftPressed = false;

		constructor: (@currentPath, @key, @parentObj, @level) ->
			obj = {}

			if @key == "ROOT" 
				obj = manager.rootJson[@key];
			else 
				obj = @parentObj[@key];

			@type = util.getType(obj);


		getObj: () ->

			if @key == "ROOT" 
				obj = manager.rootJson[@key];
			else 
				obj = @parentObj[@key];

			obj

		render: (rerender) ->

			if rerender != true
				@domEl = document.createElement('li');	
				
				$(@domEl).on 'click', (e) =>


					if @enableMode == true
						return
					else
						manager.activateLevel(@level)
						manager.selectKeyFromEl(e)
				
				$(@domEl).on 'dblclick', $.proxy @enableEditKeyMode			

			@domEl.innerHTML = "<span class='icon #{@type}'></span><span>#{@key}</span><span class='remove'>×</span>";
			@setupDataAttributes()

			$(@domEl).find('.remove').on 'click', @removeKey

			return @domEl;


		setupDataAttributes: () ->
			@domEl.dataset.key = @key;
			@domEl.dataset.level = @level;
			@domEl.dataset.parentPath = @currentPath;


		enableEditKeyMode: () =>
			@enableMode = true
			@domEl.innerHTML = "<form class='name-change-form'><input class='name-input' type='text' value='#{@key}''></input></form>"
			$(@domEl).find('.name-change-form').on 'submit', @nameChangeFormSubmitted
			$(@domEl).find('.name-input').select()


		removeKey: (e) =>
			delete @parentObj[@key]
			manager.rerenderLevel(@level)
			e.preventDefault()


		nameChangeFormSubmitted: (e) =>
			e.preventDefault()
			newName = $(@domEl).find('.name-input').val()
			
			if newName == @key
				@disableEditKeyMode()
			else if @parentObj[newName] != null && @parentObj[newName] != undefined
				alert("This key already exists")
			else
				@parentObj[newName] = @parentObj[@key]
				delete  @parentObj[@key]
				@key = newName
				manager.cleanDeeperLevels(@level+1)
				@setupDataAttributes()
				@disableEditKeyMode()


		disableEditKeyMode: (e) ->
			if @enableMode == false
				return
			@enableMode = false
			@render(true);


		highlight: () ->
			$(@domEl).addClass('selected')


		unhighlight: () ->
			$(@domEl).removeClass('selected')


		remove: () ->
			$(@domEl).remove()

	return ListElementView
