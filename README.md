Goldengate
==========

Goldengate intends to be a replacement for Cordova/PhoneGap on iOS and Mac. Why? Cordova is designed with the assumption that you don't want to know anything about native app development — and that is just plain annoing to me.

**Features:**

- built with WKWebView, Swift & CoffeeScript
- works on iOS and Mac
- asynchronous calls using Promises, not callbacks
- (WIP) nice syntax for calling plugins from JS: `Goldengate.PluginName.method(args)`
- (WIP) a compatibility layer for importing existing Cordova plugins

**Issues:**

At the moment, Goldengate is (and can be) only a proof of concept, because WKWebView can't load web pages from the app bundle. This has been fixed on the upstream repo, but it's possible that the necessary API won't be added until OS X 10.11 / iOS 9.

The workaround at the moment is to use a local server. I'm using [Pow](http://pow.cx) to point `pow.dev` to the GoldengateJS folder. If you have a different local URL, you can change it in AppDelegate.
