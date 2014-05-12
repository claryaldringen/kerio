
module.exports = (config) ->
	config.set
		basePath: './'
		frameworks: ['jasmine']
		files: [
			'bower_components/jquery/dist/jquery.js'
			'coffee/*.coffee',
			'tests/*.coffee'
		]
		autoWatch: yes
		preprocessors:
			'**/*.coffee': ['coffee']
		browsers: ['PhantomJS']
