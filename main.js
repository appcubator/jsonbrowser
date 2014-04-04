require({
    paths: {
    	"cs": './libs/cs',
        "jquery": "./libs/jquery/jquery",
        "jquery-ui": "./libs/jquery-ui/jquery-ui",
        "underscore": "./libs/underscore-amd/underscore",
        "ace": "./libs/ace/ace",
        "util": "./util",
        'coffee-script': './libs/coffee-script'
    },
    shim: {
        "jquery-ui": {
            exports: "$",
            deps: ['jquery']
        },
        "underscore": {
            exports: "_"
        },
        "ace": {
            exports: 'ace'
        },
        "util": {
        	exports: 'util'
        }
    }
}, ['cs!csmain']);