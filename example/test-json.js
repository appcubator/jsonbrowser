var json = {
  "version_id": 0,
  "string_key": "YOOOOO",
  "models": [{
    "generate": "models.model",
    "data": {
      "name": "Picture",
      "fields": [{
        "name": "datePicked",
        "type": "Date"
      }, {
        "name": "name",
        "type": "String"
      }, {
        "name": "url",
        "type": "String"
      }],
      "functions": [{
        "name": "updateUrl",
        "enableAPI": true,
        "code": "function (newUrl, cb) {\n      this.url = newUrl;\n      this.save(function(e, d){cb(e,d);});\n    }"
      }, {
        "generate": "crud.model_methods.create",
        "data": {
          "modelName": "Picture",
          "enableAPI": true,
          "name": "create"
        }
      }, {
        "generate": "crud.model_methods.find",
        "data": {
          "modelName": "Picture",
          "enableAPI": true,
          "name" : "find"
        }
      }]
    }
  }, {
    "generate": "models.model",
    "data": {
      "name": "User",
      "fields": [{
        "name": "name",
        "type": "String"
      }, {
        "name": "email",
        "type": "String"
      }, {
        "name": "username",
        "type": "String"
      }, {
        "name": "hashed_password",
        "type": "String"
      }, {
        "name": "salt",
        "type": "String"
      }],
      "functions": [{
        "name": "authenticate",
        "code": "function (plainText) {\n  /**\n   * Authenticate by checking the hashed password and provided password\n   *\n   * @param {String} plainText\n   * @return {Boolean}\n   * @api private\n   */\n    return this.encryptPassword(plainText) === this.hashed_password;\n  }"
      }, {
        "name": "makeSalt",
        "code": "function () {\n  /**\n   * Create password salt\n   *\n   * @return {String}\n   * @api private\n   */\n\n    /* Then to regenerate password, use:\n        this.salt = this.makeSalt()\n        this.hashed_password = this.encryptPassword(password)\n    */\n    return Math.round((new Date().valueOf() * Math.random())) + '';\n  }"
      }, {
        "name": "encryptPassword",
        "code": "function (password) {\n  /**\n   * Encrypt password\n   *\n   * @param {String} password\n   * @return {String}\n   * @api private\n   */\n    var crypto = require('crypto');\n    if (!password) return '';\n    return crypto.createHmac('sha1', this.salt).update(password).digest('hex');\n  }"
      }, {
        "name": "resetToken",
        "code": "function (token, cb) {\n  /**\n   * Reset auth token\n   *\n   * @param {String} token\n   * @param {Function} cb\n   * @api private\n   */\n    var self = this;\n    var crypto = require('crypto');\n    crypto.randomBytes(48, function(ex, buf) {\n      self[token] = buf.toString('hex');\n      if (cb) cb();\n    });\n  }"
      }, {
        "name": "signup",
        "enableAPI": true,
        "code": "function (username, password, password2, callback) {\n        if (password !== password2) {\n            callback('Passwords don\\'t match. Please try again.');\n        }\n        var user = new this({username: username});\n        user.salt = user.makeSalt();\n        user.hashed_password = user.encryptPassword(password);\n        user.save(function(err, data) {\n            if (err) {\n                callback(err);\n            } else {\n                callback(null, {url:'?success=true'});\n            }\n        });\n    }"
      }],
      "schemaMods": [
        "function (schema) {\n  schema.path('name').validate(function (name) {\n    return name.trim().length > 0;\n  }, 'Please provide a valid name');\n}",
        "function (schema) {\n  schema.path('email').validate(function (email) {\n    return email.trim().length > 0;\n  }, 'Please provide a valid email');\n}",
        "function (schema) {\n  schema.path('hashed_password').validate(function (hashed_password) {\n    return hashed_password.length > 0;\n  }, 'Please provide a password');\n}"
      ]
    }
  }],
  "packages": {
    "express": "3.4.4",
    "ejs": "0.8.5",
    "flickr": "0.1.0",
    "mongoose": "3.8.1"
  },
  "modules": {
    "custom": {
      "custom.txt": "this is custom code\n"
    }
  },
  "header": "",
  "scripts": "",
  "templates": [{
    "generate": "templates.page",
    "data": {
      "name": "Homepage",
      "head": "<script src=\"//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min.js\"></script>",
      "uielements": {
        "generate": "templates.layoutSections",
        "data": [
        {
          "generate": "templates.navbar",
          "data": {
            "isFixed": true,
            "brandName": null,
            "isHidden": false,
            "links": [{
              "url": "internal://Homepage",
              "title": "Homepage"
            }]
          }
        },
        {
          "generate": "templates.footer",
          "data": {
            "isFixed": true,
            "customText": "<a href='http://appcubator.com'>Powered by Appcubator</a>",
            "isHidden": false,
            "links": [{
              "url": "internal://Homepage",
              "title": "Homepage"
            }]
          }
        },
        {
          "generate": "templates.layoutSection",
          "data": {
            "className": "jumbotron",
            "columns" : [
              {
                "generate": "templates.layoutColumn",
                "data": {
                  "layout": "12",
                  "uielements": [
                    {
                      "generate": "uielements.design-header",
                      "data": {
                        "type": "header",
                        "content": "Teach Me How To DJ",
                        "layout": {
                          "row": 0,
                          "col": 0
                        },
                        "className": "",
                        "style": ""
                      }
                    }
                  ]
                }
              },
              {
                "generate": "templates.layoutColumn",
                "data": {
                  "layout" : "8",
                  "uielements": [
                    {
                      "generate": "crud.uielements.create",
                      "data": {
                        "type": "create-form",
                        "table": "Picture",
                        "layout": {
                          "row": 0,
                          "col": 0
                        },
                        "className": "",
                        "style": "",
                        "fields": [{
                          "generate": "root.uielements.form-field",
                          "data": {
                            "field_name": "name",
                            "type": "text",
                            "placeholder": "Name",
                            "displayType": "single-line-text"
                          }
                        }, {
                          "generate": "root.uielements.form-field",
                          "data": {
                            "field_name": "url",
                            "type": "text",
                            "placeholder": "URL",
                            "displayType": "single-line-text"
                          }
                        }],
                        "id": "testform",
                        "redirect": "/?success=true"
                      }
                    }
                  ]
                }
              },
              {
                "generate": "templates.layoutColumn",
                "data": {
                  "layout" : "4",
                  "uielements": [
                    {
                      "generate": "uielements.design-button",
                      "data": {
                        "type": "button",
                        "content": "Refresh >",
                        "layout": {
                          "row": 1,
                          "col": 0
                        },
                        "href": "http://TOOLOBAPAGE.html",
                        "className": "btn",
                        "style": ""
                      }
                    }
                  ]
                }
              }
            ]
           }
        }]
      }
    }
  }],
  "routes": [{
    "generate": "routes.staticpage",
    "data": {
      "url": [],
      "name": "Homepage"
    }
  }],
  "plugins": {},
  "config": {
    "generate": "app.config",
    "data": {
      "customCodeChunks": []
    }
  },
  "info": {
    "logo": "https://www.filepicker.io/api/file/ZJDTP6ZWTkORSHrvjGZZ",
    "keywords": "",
    "description": ""
  }
};
