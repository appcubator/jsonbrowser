{util} = require './util'
{ListElementView} = require './ListElementView'

class LevelView 

	liViews = {}
	currentKey = null

	constructor: (@title, @curObj, @parentObj, @parentPath, @level) ->

		@setKeys()

		if util.isRootPath @parentPath
			@currentPath = title
		else
			@currentPath = parentPath + "."  + title

		@level = level || 0;

	setKeys: () ->
		@keys = null

	addKeyValue: (key, val) ->
		while (@curObj[key])
			key = "Copy_" + key

		@curObj[key] = val
		@render(true)

	render: (rerender) ->

		@superView.highlightPrevKey(@level, @title);

		if !rerender
			levelEl = document.createElement('ul');
			levelEl.className = "level one";
			@domEl = levelEl;
			document.body.appendChild(@domEl);
		else
			@setKeys()
			@domEl.innerHTML = ''

		liEl = document.createElement('li');
		liEl.className = 'title';
		liEl.innerHTML = this.title;
		@domEl.appendChild(liEl);

		for key in @keys || []
			liView = new ListElementView @currentPath, key, @curObj, @level
			liView.superView = @superView
			liViews[key] = liView
			
			liEl = liView.render()
			@domEl.appendChild(liEl);

		$(@domEl).sortable({
			"stop": @sorted, 
			"placeholder": "ui-sortable-placeholder", 
			"cancel": ".add-new, .title"
		});

		$(@domEl).append(["<li class='add-new' data-type='object'><span class='icon object'></span>New Object</li>",
			   "<li class='add-new' data-type='array'><span class='icon array'></span>New Array</li>",
			   "<li class='add-new' data-type='string'><span class='icon string'></span>New String</li>",
			   "<li class='add-new' data-type='number'><span class='icon number'></span>New Number</li>"].join('\n'))

		$(@domEl).find('.add-new').on 'click', (e) => @clickedAddNew e

		@domEl

	sorted: () =>
		console.log "sorted"

	clickedAddMore: () =>

		$(@domEl).find('.add-more').html(str)

	getLiView: (key) =>
		liViews[key]

	clickedAddNew: (e) =>
		type = e.currentTarget.dataset.type;
		@showKeyInput(type)


	showKeyInput: (type) ->
		$(@domEl).find('.add-new').hide();
		$(@domEl).append( "<li class='new-item-line'><form class='new-name-form'><input class='name-input' type='text'></input></form></li>");
		newName = $(@domEl).find('.name-input').focus()
		$(@domEl).find('.new-name-form').on 'submit', (e) => @newNameFormSubmitted(e, type)


	newNameFormSubmitted: (e, type) =>
		e.preventDefault()
		newName = $(@domEl).find('.name-input').val()
		@addNewValue(newName, type)
		$(@domEl).find('.new-item-line').remove();


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

		@render(true)

	highlightKey: (keyToSelect) ->

		for key,val of liViews
			val.unhighlight()
			val.disableEditKeyMode()

		if @selectedLiView
			@selectedLiView.unhighlight()

		newSelectedLiView = liViews[keyToSelect]
		newSelectedLiView.highlight()
		
		currentKey = keyToSelect
		@selectedLiView = newSelectedLiView

	highlightKeys: (keys) ->
		
		for key,val of liViews
			val.unhighlight()
			val.disableEditKeyMode()

		if @selectedLiView
			@selectedLiView.unhighlight()

		for keyToHighlight in keys
			liViews[keyToHighlight].highlight()


	navigateUp: () ->
		
		if currentKey == null
			currentKey = @keys[@keys.length - 1]
		else
			curInd = @keys.indexOf(currentKey)
			currentKey = @keys[curInd - 1]

		@superView.navigateToKey currentKey, @parentPath, @level


	navigateDown: () ->
		if currentKey == null
			currentKey = @keys[0]
		else
			curInd = @keys.indexOf(currentKey)
			currentKey = @keys[curInd + 1]

		@superView.navigateToKey currentKey, @parentPath, @level


	remove: () ->
		$(@domEl).remove()


exports.LevelView = LevelView

