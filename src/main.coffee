Global = {}
Global.$ = require "jquery"

if window
    window.Framer = Global
    window._ = require "underscore"

    _.extend window, Global

    Manager = reqiure "Manager"
    window.manager = new Manager()
    console.log manager
    manager.setupEditor({
        "yolo" : "hey",
        "zolo" : [1,2,3]
    })
