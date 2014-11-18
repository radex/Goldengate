Goldengate
==========

Goldengate intends to be a replacement for Cordova/PhoneGap on iOS and Mac. Why? Cordova is designed with the assumption that you don't want to know anything about native app development — and that is just plain annoing to me.

## Features

- built with WKWebView, Swift & CoffeeScript
- works on iOS and Mac
- very lightweight (no support for legacy systems, etc.)
- asynchronous calls using Promises, not callbacks
- (WIP) nice syntax for calling plugins from JS: `Goldengate.PluginName.method(args)`
- (WIP) a compatibility layer for importing existing Cordova plugins

## Issues

At the moment, Goldengate is (and can be) only a proof of concept, because WKWebView can't load web pages from the app bundle. This has been fixed on the upstream repo, but it's possible that the necessary API won't be added until OS X 10.11 / iOS 9.

## Dependencies/setup

Xcode project requires Xcode 6.1 running on OS X 10.10. The web component requires CoffeeScript (accessible globally via `coffee` command).

You need [Pow](http://pow.cx) to serve the web page locally (as noted above, WKWebView can't load from app bundle). Point `~/.pow/goldengate` to the GoldengateJS directory. Alternatively, if you're using a different web server, edit the URL in AppDelegate.swift

If you're working on the web component, be sure to run the watcher script (`./watch` from GoldengateJS) beforehand. It will listen to changes in CoffeeScript files and compile them.

## Contributing

If this sounds like something you'd want for yourself, please feel free to contribute and open a pull request. There's a bunch of open issues you can choose from. And if you want to talk about the project some more, [email me](mailto:this.is@radex.io)
