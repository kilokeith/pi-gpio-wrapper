gpio 	= require "pi-gpio"
_ 		= require "lodash"
Q 		= require "q"
events 	= require "events"


module.exports =
	class Pin
		constructor: (settings) ->
			@deffered = Q.defer()
			@promise = @deffered.promise
			@pin = settings.pin
			@name = settings.name
			@direction = settings.direction
			
			@emitter = new events.EventEmitter
			
			@interval = 100
			@timer = null
			
			@lastVal = null
			
			@open()
		open: () =>
			deffered = Q.defer()
			gpio.open @pin, @direction, (err) =>
				if err?
					console.error('pin open error', err) 
					@deffered.reject(err)
				else
					console.log "#{@name} #{@pin} is ready"
					@deffered.resolve()
		close: () =>
			deffered = Q.defer()
			
			@unwatch()
			gpio.close @pin, (err) =>
				if err?
					console.error('pin close error', err)
					deffered.reject(err)
				else
					deffered.resolve()
			deffered.promise
		write: (val=0) =>
			deffered = Q.defer()
			gpio.write @pin, val, (err) =>
				if err?
					console.error('pin write error', @pin, err)
					deffered.reject(err)
				else
					#console.log 'wrote value', val
					deffered.resolve(val)
					
			deffered.promise

		read: () =>
			deffered = Q.defer()
			gpio.read @pin, (err, val) =>
				if err?
					console.error('pin write error', err)
					deffered.reject(err)
				else
					deffered.resolve(val)
				
			deffered.promise
		
		_watchRead: () =>
			@read().then (val) =>
				if @lastVal isnt val
					@emitter.emit 'change', val
					@lastVal = val
		
		watch: () =>
			clearTimeout(@timer) if @timer?
			@timer = setInterval () =>
				@_watchRead()
			, @interval
		
		unwatch: () =>
			clearInterval(@timer) if @timer?
		
		on: (evt=null, f=null) =>
			@emitter.on evt, f
			
		off: (evt=null, f=null) =>
			if f?
				@emitter.removeListener(evt, f)
			else
				@emitter.removeAllListeners(evt)