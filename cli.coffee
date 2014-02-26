rg = require('./rgulp.coffee')(silent: true, root: process.cwd())

util = require 'util'
kexec = require 'kexec'
sh = require 'execSync'
fs = require 'fs'

targetFolder = './.rgulp'

log = (msg)-> 
	console.log "[rgulp] #{msg}" unless args.silent

logError = (msg)-> 
	console.error "[rgulp] ERROR: #{msg}"

run = (cmd, msg)->
	log "running: #{cmd}"
	result = sh.exec cmd
	
	if result.code != 0 
		logError msg.err 
		logError result.stdout
		process.exit 1
	

runGulp = (cliArgs)->
	Gulpfile = ".rgulp/gulpfile.js"
	base = "gulp --gulpfile #{Gulpfile}"
	moduleBins = rg.expand "#{targetFolder}/node_modules/.bin"
	kexec "PATH=#{moduleBins}:$PATH #{base} #{cliArgs} --root #{rg.root}"

# does git clone in target
clone = ->
	url = rg.source.src
	checkout = rg.source.checkout
	cmd = "git clone #{url} -o rgulp -b #{checkout} --recursive #{targetFolder}"
	log "Cloning rgulp repository.."
	run cmd, err: "Cloning failed"

repoExists = -> repoExists = fs.existsSync "#{targetFolder}/.git"
# downloads repo and updates the .rgulp folder
sync = ->
	if repoExists()
		log "Using existing repo in #{targetFolder}"
	else
		logError "No git repo was found in #{targetFolder}."
		logError "First do `rgulp prepare` to initialize everything."
		process.exit 1
	cmd = "git --git-dir='#{targetFolder}/.git' pull rgulp #{rg.source.checkout}"
	run cmd, err: "Sync failed"
	log "Finished sync"



# it runs the prepare script of the repo
# with cwd = .rgulp folder
# if no bin/prepare only npm install is run
prepare = ->
	clone() unless repoExists()
	prepareScript = "#{targetFolder}/bin/prepare"
	prepareExists = fs.existsSync prepareScript
	if prepareExists
		log "Prepare script detected in .rgulp"
		cmd = prepareScript
		run cmd, err: ".rgulp prepare script failed"
		log "Prepare script completed"
	else
		log "No prepare script was detected in .rgulp"
		log "Installing .rgulp dependencies, please be patient."
		cmd = "cd #{targetFolder} && npm install"
		run cmd, err: "`npm install` inside .rgulp failed"
		log "Dependencies installed, run `rgulp` as you'd call regular gulp. e.g. `rgulp jade`"


# skip node and command name in cli args
args = process.argv.slice 2

switch args[0]
	when 'sync' then sync()
	when 'prepare' then prepare()
	else 
		sync()
		runGulp args.join ' '