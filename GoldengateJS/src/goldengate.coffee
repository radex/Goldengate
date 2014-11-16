class @Goldengate
	@_messageCount = 0
	@_callbackDeferreds = {}
	
	@dispatch: (plugin, method, args) ->
		callbackID = @_messageCount
		message = { plugin, method, arguments: args, callbackID }
		window.webkit.messageHandlers.goldengate.postMessage(message)
		@_messageCount++
		
		d = new Deferred
		@_callbackDeferreds[callbackID] = d
		d.promise
	
	@callBack: (callbackID, isSuccess, valueOrReason) ->
		d = @_callbackDeferreds[callbackID]
		if isSuccess
			d.resolve(valueOrReason[0])
		else
			d.reject(valueOrReason[0])
		
		delete @_callbackDeferreds[callbackID]

$ ->
	# No arguments, no return value
	Goldengate.dispatch("ReadLater", "makeSomethingHappen", [])
	
	# Passing arguments
	Goldengate.dispatch("ReadLater", "saveUrl", ["http://foo.bar", "Lorem ipsum"])
	
	# Return value
	Goldengate.dispatch("ReadLater", "savedUrls", [])
		.then (list) ->
			console.log list
	
	# Asynchronous call (resolved)
	Goldengate.dispatch("ReadLater", "fetchSomething", [])
		.then (value) ->
			console.log value
	
	# Asynchronous call (rejected)
	Goldengate.dispatch("ReadLater", "asyncError", [])
		.then (value) ->
			console.log value # never called
		, (reason) ->
			console.log "Failed: " + reason
	