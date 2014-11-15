$ ->
	message = { plugin: "Foo", method: "Bar", arguments: [1, "baz", false] }
	window.webkit.messageHandlers.goldengate.postMessage(message)