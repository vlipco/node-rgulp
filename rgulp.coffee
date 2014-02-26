module.exports = (args)->
	#_ = require 'underscore'



	# avoid any output to stdout
	# useful for importing libraries generating bash output
	silent = args.silent || false
	root = args.root
	

	log = (msg)-> 
		console.log "[rgulp] #{msg}" unless args.silent

	logError = (msg)-> 
		console.error "[rgulp] ERROR: #{msg}"

	
	unless root
		logError "Rgulp was required without passing 'root' in the options"
		sample = "var rg = require('rgulp')({root: gutil.env.root})"
		logError "Correct format should be something similar to: `#{sample}`"
		process.exit 1

	log "Rgulp root set to #{root}"

	path = require 'path'
	fs = require 'fs'
	

	class RGulp

		# can be handy inside gulpfile
		log: log
		logError: logError

		# source has src and optionally commit or branch
		# TODO add tag support?
		# config is a hash exposed to the gulpfile as rg.config
		constructor: (options)->
			@source = options.source
			unless options.source.checkout
				@source.checkout = 'master'
			@config = options.config
			@root = root

		expand: (relative)->
			path.resolve @root, relative


	
	isCoffee = fs.existsSync path.resolve root, 'RGfile.coffee'
	fileName = if isCoffee then 'RGfile.coffee' else 'RGfile.js'
	filePath = path.resolve root, fileName
	
	if !isCoffee && !fs.existsSync(filePath)
		logError "RGfile was not found either as javascript or coffeescript"
		logError "Rgulp tried to find them in #{path.dirname filePath}"
		process.exit 1

	#log "Using #{filePath} in #{process.cwd()}"

	options = require path.resolve filePath

	unless options.source
		logError "#{filePath} didn't include 'source' key in module.exports"
		process.exit 1
	
	return new RGulp options