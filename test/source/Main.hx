package;

import extension.webviewcore.WebView;

using StringTools;

class Main extends lime.app.Application
{
	public function new():Void
	{
		super();

		WebView.onPageStarted.add(function(url:String):Void
		{
			trace('Page started loading: $url');
		});

		WebView.onPageFinished.add(function(url:String):Void
		{
			trace('Page finished loading: $url');
		});

		WebView.onUrlLoading.add(function(url:String):Void
		{
			trace('Loading URL: $url');
		});

		WebView.onCloseButtonClicked.add(function():Void
		{
			trace('Clearing data.');

			WebView.clearCache(true);
			WebView.clearHistory();
			WebView.clearFormData();

			trace('Closing webview from url loading.');

			WebView.close();

			trace('Clearing cookies.');

			WebView.clearCookies();
		});

		WebView.init();
	}

	public override function onWindowCreate():Void
	{
		WebView.openWithURL('https://google.com', false, true);
	}

	public override function render(context:lime.graphics.RenderContext):Void
	{
		switch (context.type)
		{
			case OPENGL, OPENGLES, WEBGL:
				context.webgl.clearColor(0.75, 1, 0, 1);
				context.webgl.clear(context.webgl.COLOR_BUFFER_BIT);
			default:
		}
	}
}
