dispatch = (plugin, method, args) ->
	message = { plugin, method, arguments: args }
	window.webkit.messageHandlers.goldengate.postMessage(message)

$ ->
	# No arguments, no return value
	dispatch("ReadLater", "makeSomethingHappen", [])
	
	# Passing arguments
	dispatch("ReadLater", "saveUrl", ["http://foo.bar", "Lorem ipsum"])
	
	# Return value
	dispatch("ReadLater", "savedUrls", [])
	
	# Asynchronous call (resolved)
	dispatch("ReadLater", "fetchSomething", [])
	
	# Asynchronous call (rejected)
	dispatch("ReadLater", "asyncError", [])
	