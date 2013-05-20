### glob-expand

A (sync) glob / minimatch call using [gruntjs](https://github.com/gruntjs/grunt)'s `file.expand`.

It has only a minimum of dependencies (glob & lodash).

Its actually a copy/paste of just 2 functions from Gruntjs's v0.4.1 [grunt/file.js](https://github.com/gruntjs/grunt/blob/master/lib/grunt/file.js)

# Examples:

```coffeescript
	expand = require 'glob-expand'

	# may the original node-glob be with you (should you need it):
	glob = expand.glob

	expand {filter: 'isFile', cwd: '../'}, ['**/*.*', '!exclude/these/**/*.*']
	# returns all files in cwd ['file1', 'file2',...] but excluding
	# those under directory 'exclude/these'

	# These are the same
	expand {cwd: '../..'}, ['**/*.*', '!node_modules/**/*.*']
	expand {cwd: '../..'}, '**/*.*', '!node_modules/**/*.*'

	# These are the same too:
	expand {}, ['**/*.*', '!**/*.js']
	expand {}, '**/*.*', '!**/*.js'
	expand ['**/*.*', '!**/*.js']
	expand '**/*.*', '!**/*.js'
```

See [gruntjs files configuration](http://gruntjs.com/configuring-tasks#files)
and [node-glob](https://github.com/isaacs/node-glob) for more options.

Sorry no tests, I assumed gruntjs's tests are sufficient ;-)