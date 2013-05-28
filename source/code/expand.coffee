_ = require 'lodash'
glob = require 'glob'
fs = require 'fs'
path = require 'path'

# Return an array of all file paths that match the given wildcard patterns.
expand = (args...)->
  # If the first argument is an options object, save those options to pass
  # into the file.glob.sync method.
  options = if _.isObject(args[0]) then args.shift() else {}

  # Use the first argument if it's an Array, otherwise convert the arguments
  # object to an array and use that.
  patterns = (if _.isArray(args[0]) then args[0] else args)

  # Return empty set if there are no patterns or filepaths.
  return []  if patterns.length is 0

  # Return all matching filepaths.
  matches = processPatterns(patterns, (pattern) ->
    # Find all matching files for this pattern.
    if _.isString pattern
      glob.sync pattern, options
    else
      if _.isRegExp pattern
        _.filter (glob.sync '**/*.*', options), (filename)->
          filename.match pattern
      else
        []
  )

  # Filter result set?
  if options.filter
    matches = matches.filter((filepath) ->
      filepath = path.join(options.cwd or "", filepath)
      try
        if _.isFunction options.filter
          return options.filter(filepath)
        else
          # If the file is of the right type and exists, this should work.
          return fs.statSync(filepath)[options.filter]()
      catch e

        # Otherwise, it's probably not the right type.
        return false
    )
  matches


# Process specified wildcard glob patterns or filenames against a
# callback, excluding and uniquing files in the result set.
processPatterns = (patterns, fn) ->

  # Filepaths to return.
  result = []

  # Iterate over flattened patterns array.
  _.flatten(patterns).forEach (pattern) ->

    # If the first character is ! it should be omitted
    exclusion = _.isString(pattern) and pattern.indexOf("!") is 0

    # If the pattern is an exclusion, remove the !
    pattern = pattern[1..] if exclusion

    # Find all matching files for this pattern.
    matches = fn pattern
    if exclusion
      # If an exclusion, remove matching files.
      result = _.difference(result, matches)
    else
      # Otherwise add matching files.
      result = _.union(result, matches)

  result

module.exports = expand

_.extend expand, {
  glob
  VERSION: if VERSION? then VERSION else '{NO_VERSION}'
}

#console.log expand {cwd: '../..'}, ['**/*.js', /\.coffee$/, '!node_modules/**/*.*', /\.md$/ ]
#console.log expand {cwd: '../..'}, '**/*.*', '!node_modules/**/*.*'

#console.log expand {}, ['**/*.*', '!**/*.js']
#console.log expand {}, '**/*.*', '!**/*.js'
#console.log expand {cwd:'../..'}, [/\.coffee$/] #'**/*.*' #, '!**/*.js'