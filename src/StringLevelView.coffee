{util} = require './util'
{LevelView} = require './LevelView'
ace = require('brace');


class StringLevelView extends LevelView

	render: () ->

		@superView.highlightPrevKey(@level, @title)

		# create a container div
		@domEl = document.createElement('div')
		@domEl.className = "level editor"

		# add the title
		titleEl = document.createElement('div')
		titleEl.innerHTML = @title
		titleEl.className = "title"
		@domEl.appendChild titleEl

		# add the editor
		@editor = document.createElement('div')
		@editor.className = "text-editor"
		@editor.id = "textEditor"

		@domEl.appendChild(@editor)
		document.body.appendChild(@domEl)

		# setup the ace editor
		@editor = ace.edit("textEditor")
		require('brace/mode/javascript');
		require('brace/theme/monokai');
		@editor.setTheme("brace/theme/monokai");
		@editor.getSession().setMode("brace/mode/javascript");
		@editor.setValue(@parentObj[@title])

		# bind value changes
		@editor.getSession().on 'change', (e) =>
			val = @editor.getValue();
			@parentObj[@title] = val;

exports.StringLevelView = StringLevelView