$ ->
	message = { plugin: "Foo", method: "Bar", arguments: ["foo", 10, 3.14, false, null] }
	window.webkit.messageHandlers.goldengate.postMessage(message)