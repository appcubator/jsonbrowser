# importing the libraries
Global = {}
$ = require "jquery"

$ = jQuery = require('jquery');
module.exports = require('jquery-ui-browserify');

Global.$ = $


if window
	window._ = require "underscore"
	# adding the libraries to window
	_.extend window, Global

	# expose the library to window as JSONBrowser
	{Manager} = require "./Manager"
	window.JSONBrowser = Manager
