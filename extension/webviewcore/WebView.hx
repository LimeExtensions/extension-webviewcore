package extension.webviewcore;

#if ios
import cpp.Callable;
import cpp.ConstCharStar;
import cpp.RawConstPointer;
#elseif android
import lime.system.JNI;
#end
import lime.app.Event;

/**
 * This class provides a cross-platform interface for WebView functionality.
 */
#if ios
@:buildXml('<include name="${haxelib:extension-webviewcore}/project/webview-ios/Build.xml" />')
@:headerInclude('webview_core.hpp')
#end
class WebView
{
	/** Event triggered when a page has finished loading. */
	public static final onPageFinished:Event<String->Void> = new Event<String->Void>();

	/** Event triggered when a page starts loading. */
	public static final onPageStarted:Event<String->Void> = new Event<String->Void>();

	/** Event triggered when a URL is about to be loaded. */
	public static final onUrlLoading:Event<String->Void> = new Event<String->Void>();

	/** Event triggered when the loading progress changes (avaliable on Android). */
	public static final onProgressChanged:Event<Int->Void> = new Event<Int->Void>();

	#if android
	/**
	 * Cache for storing created static JNI method references.
	 */
	@:noCompletion
	private static var staticMethodsCache:Map<String, Dynamic> = [];
	#end

	/**
	 * Initializes the WebView system. Call this before using any other methods.
	 */
	public static function init():Void
	{
		#if ios
		final callbacks:WebViewCallbacks = new WebViewCallbacks();
		callbacks.onPageStarted = cpp.Callable.fromStaticFunction(onPageStartedNative);
		callbacks.onPageFinished = cpp.Callable.fromStaticFunction(onPageFinishedNative);
		callbacks.onUrlLoading = cpp.Callable.fromStaticFunction(onUrlLoadingNative);
		initWebView(cpp.RawConstPointer.addressOf(callbacks));
		#elseif android
		final initJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'init', '(Lorg/haxe/lime/HaxeObject;)V');

		if (initJNI != null)
			initJNI(new WebViewCallbackObject());
		#end
	}

	/**
	 * Opens a WebView instance and loads a URL into the WebView.
	 * 
	 * @param url The URL to load.
	 */
	public static function openWithURL(url:String):Void
	{
		#if ios
		openWithURLWebView(url);
		#elseif android
		final openWithURLJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'openWithURL', '(Ljava/lang/String;)V');

		if (openWithURLJNI != null)
			openWithURLJNI(url);
		#end
	}

	/**
	 * Opens a WebView instance and loads data into the WebView.
	 * 
	 * @param data The data to load.
	 * @param mimeType The MIME type of the data.
	 * @param encoding The encoding of the data.
	 */
	public static function openWithData(data:String, mimeType:String, encoding:String):Void
	{
		#if ios
		openWithDataWebView(data, mimeType, encoding);
		#elseif android
		final openWithDataJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'openWithData', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');

		if (openWithDataJNI != null)
			openWithDataJNI(data, mimeType, encoding);
		#end
	}

	/**
	 * Checks if the WebView is currently opened.
	 * @return `true` if the web view is open, false otherwise.
	 */
	public static function isOpened():Bool
	{
		#if ios
		return isOpenedWebview();
		#elseif android
		final isOpenedJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'isOpened', '()Z');

		if (isOpenedJNI != null)
			return isOpenedJNI();

		return false;
		#else
		return false;
		#end
	}

	/**
	 * Closes and destroys the WebView instance.
	 */
	public static function close():Void
	{
		#if ios
		closeWebView();
		#elseif android
		final closeJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'close', '()V');

		if (closeJNI != null)
			closeJNI();
		#end
	}

	/**
	 * Loads a URL into the WebView.
	 * 
	 * @param url The URL to load.
	 */
	public static function loadURL(url:String):Void
	{
		#if ios
		loadURLWebView(url);
		#elseif android
		final loadURLJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'loadURL', '(Ljava/lang/String;)V');

		if (loadURLJNI != null)
			loadURLJNI(url);
		#end
	}

	/**
	 * Loads data into the WebView.
	 * 
	 * @param data The data to load.
	 * @param mimeType The MIME type of the data.
	 * @param encoding The encoding of the data.
	 */
	public static function loadData(data:String, mimeType:String, encoding:String):Void
	{
		#if ios
		loadDataWebView(data, mimeType, encoding);
		#elseif android
		final loadDataJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'loadData', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');

		if (loadDataJNI != null)
			loadDataJNI(data, mimeType, encoding);
		#end
	}

	/**
	 * Checks if the WebView can navigate back.
	 * 
	 * @return `true` if the WebView can go back, false otherwise.
	 */
	public static function canGoBack():Bool
	{
		#if ios
		return canGoBackWebView();
		#elseif android
		final canGoBackJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'canGoBack', '()Z');

		if (canGoBackJNI != null)
			return canGoBackJNI();

		return false;
		#else
		return false;
		#end
	}

	/**
	 * Navigates back in the WebView's history.
	 */
	public static function goBack():Void
	{
		#if ios
		goBackWebView();
		#elseif android
		final goBackJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'goBack', '()V');

		if (goBackJNI != null)
			goBackJNI();
		#end
	}

	/**
	 * Checks if the WebView can navigate forward.
	 * 
	 * @return `true` if the WebView can go forward, false otherwise.
	 */
	public static function canGoForward():Bool
	{
		#if ios
		return canGoForwardWebView();
		#elseif android
		final canGoForwardJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'canGoForward', '()Z');

		if (canGoForwardJNI != null)
			return canGoForwardJNI();

		return false;
		#else
		return false;
		#end
	}

	/**
	 * Navigates forward in the WebView's history.
	 */
	public static function goForward():Void
	{
		#if ios
		goForwardWebView();
		#elseif android
		final goForwardJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'goForward', '()V');

		if (goForwardJNI != null)
			goForwardJNI();
		#end
	}

	/**
	 * Reloads the current page in the WebView.
	 */
	public static function reload():Void
	{
		#if ios
		reloadWebView();
		#elseif android
		final reloadJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'reload', '()V');

		if (reloadJNI != null)
			reloadJNI();
		#end
	}

	/**
	 * Stops the current loading operation.
	 */
	public static function stopLoading():Void
	{
		#if ios
		stopLoadingWebView();
		#elseif android
		final stopLoadingJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'stopLoading', '()V');

		if (stopLoadingJNI != null)
			stopLoadingJNI();
		#end
	}

	/**
	 * Clears the WebView's cache.
	 * 
	 * @param includeDiskFiles Whether to include disk files in the clear operation (avaliable on Android).
	 */
	public static function clearCache(?includeDiskFiles:Bool):Void
	{
		#if ios
		clearCacheWebView();
		#elseif android
		final clearCacheJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'clearCache', '(Z)V');

		if (clearCacheJNI != null)
			clearCacheJNI(includeDiskFiles);
		#end
	}

	/**
	 * Clears the WebView's history (avaliable on Android).
	 */
	public static function clearHistory():Void
	{
		#if android
		final clearHistoryJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'clearHistory', '()V');

		if (clearHistoryJNI != null)
			clearHistoryJNI();
		#end
	}

	/**
	 * Clears the WebView's form data (avaliable on Android).
	 */
	public static function clearFormData():Void
	{
		#if android
		final clearFormDataJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'clearFormData', '()V');

		if (clearFormDataJNI != null)
			clearFormDataJNI();
		#end
	}

	/**
	 * Clears all shared cookies used by all WebViews in the app.
	 */
	public static function clearCookies():Void
	{
		#if ios
		clearCookiesWebView();
		#elseif android
		final clearCookiesJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/WebViewCore', 'clearCookies', '()V');

		if (clearCookiesJNI != null)
			clearCookiesJNI();
		#end
	}

	#if ios
	@:noCompletion
	private static function onPageStartedNative(url:ConstCharStar):Void
	{
		if (url != null)
			onPageStarted.dispatch((url : String));
	}

	@:noCompletion
	private static function onPageFinishedNative(url:ConstCharStar):Void
	{
		if (url != null)
			onPageFinished.dispatch((url : String));
	}

	@:noCompletion
	private static function onUrlLoadingNative(url:ConstCharStar):Void
	{
		if (url != null)
			onUrlLoading.dispatch((url : String));
	}

	@:native('WebView_Init')
	@:noCompletion
	extern static function initWebView(callbacks:RawConstPointer<WebViewCallbacks>):Void;

	@:native('WebView_OpenWithURL')
	@:noCompletion
	extern static function openWithURLWebView(url:ConstCharStar):Void;

	@:native('WebView_OpenWithData')
	@:noCompletion
	extern static function openWithDataWebView(data:ConstCharStar, mimeType:ConstCharStar, encoding:ConstCharStar):Void;

	@:native('WebView_IsOpened')
	@:noCompletion
	extern static function isOpenedWebview():Bool;

	@:native('WebView_Close')
	@:noCompletion
	extern static function closeWebView():Void;

	@:native('WebView_LoadURL')
	@:noCompletion
	extern static function loadURLWebView(url:ConstCharStar):Void;

	@:native('WebView_LoadData')
	@:noCompletion
	extern static function loadDataWebView(data:ConstCharStar, mimeType:ConstCharStar, encoding:ConstCharStar):Void;

	@:native('WebView_CanGoBack')
	@:noCompletion
	extern static function canGoBackWebView():Bool;

	@:native('WebView_GoBack')
	@:noCompletion
	extern static function goBackWebView():Void;

	@:native('WebView_CanGoForward')
	@:noCompletion
	extern static function canGoForwardWebView():Bool;

	@:native('WebView_GoForward')
	@:noCompletion
	extern static function goForwardWebView():Void;

	@:native('WebView_Reload')
	@:noCompletion
	extern static function reloadWebView():Void;

	@:native('WebView_StopLoading')
	@:noCompletion
	extern static function stopLoadingWebView():Void;

	@:native('WebView_ClearCache')
	@:noCompletion
	extern static function clearCacheWebView():Void;

	@:native('WebView_ClearCookies')
	@:noCompletion
	extern static function clearCookiesWebView():Void;
	#elseif android
	/**
	 * Retrieves or creates a cached static method reference.
	 * @param className The name of the Java class containing the method.
	 * @param methodName The name of the method to call.
	 * @param signature The JNI method signature string (e.g., "()V", "(Ljava/lang/String;)V").
	 * @param cache Whether to cache the result (default true).
	 * @return A dynamic reference to the static method, or null if it couldn't be created.
	 */
	@:noCompletion
	private static function createJNIStaticMethod(className:String, methodName:String, signature:String, cache:Bool = true):Null<Dynamic>
	{
		@:privateAccess
		className = JNI.transformClassName(className);

		final key:String = '$className::$methodName::$signature';

		if (cache && !staticMethodsCache.exists(key))
			staticMethodsCache.set(key, JNI.createStaticMethod(className, methodName, signature));
		else if (!cache)
			return JNI.createStaticMethod(className, methodName, signature);

		return staticMethodsCache.get(key);
	}
	#end
}

#if ios
@:buildXml('<include name="${haxelib:extension-webviewcore}/project/webview-ios/Build.xml" />')
@:include('webview_core.hpp')
@:structAccess
@:native('WebViewCallbacks')
extern class WebViewCallbacks
{
	function new():Void;

	var onPageFinished:Callable<(url:ConstCharStar) -> Void>;
	var onPageStarted:Callable<(url:ConstCharStar) -> Void>;
	var onUrlLoading:Callable<(url:ConstCharStar) -> Void>;
}
#elseif android
@:noCompletion
private class WebViewCallbackObject #if (lime >= "8.0.0") implements lime.system.JNI.JNISafety #end
{
	public function new():Void {}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onPageFinished(url:String):Void
	{
		if (WebView.onPageFinished != null)
			WebView.onPageFinished.dispatch(url);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onPageStarted(url:String):Void
	{
		if (WebView.onPageStarted != null)
			WebView.onPageStarted.dispatch(url);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onUrlLoading(url:String):Void
	{
		if (WebView.onUrlLoading != null)
			WebView.onUrlLoading.dispatch(url);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onProgressChanged(newProgress:Int):Void
	{
		if (WebView.onProgressChanged != null)
			WebView.onProgressChanged.dispatch(newProgress);
	}
}
#end
