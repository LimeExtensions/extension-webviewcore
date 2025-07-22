package org.haxe.extension;

import android.app.Activity;

import android.os.Bundle;

import android.view.ViewGroup;

import android.webkit.CookieManager;

import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import android.widget.RelativeLayout;

import org.haxe.extension.Extension;

import org.haxe.lime.HaxeObject;

public class WebViewCore extends Extension
{
	private static HaxeObject haxeObject = null;
	private static WebView webView = null;

	public static void init(HaxeObject object)
	{
		haxeObject = object;
	}

	public static void openWithURL(final String url)
	{
		if (webView == null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					webView = new WebView(mainActivity);

					webView.getSettings().setJavaScriptEnabled(true);
					webView.getSettings().setDomStorageEnabled(true);

					webView.getSettings().setUseWideViewPort(true);
					webView.getSettings().setLoadWithOverviewMode(true);

					webView.getSettings().setMediaPlaybackRequiresUserGesture(false);

					webView.setWebViewClient(new WebViewClient()
					{
						@Override
						public void onPageFinished(WebView view, String url)
						{
							if (haxeObject != null)
								haxeObject.call("onPageFinished", new Object[]{url});
						}

						@Override
						public void onPageStarted(WebView view, String url, android.graphics.Bitmap favicon)
						{
							if (haxeObject != null)
								haxeObject.call("onPageStarted", new Object[]{url});
						}

						@Override
						public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request)
						{
							if (haxeObject != null)
								haxeObject.call("onUrlLoading", new Object[]{ request.getUrl().toString() });

							return super.shouldOverrideUrlLoading(view, request);
						}
					});

					webView.setWebChromeClient(new WebChromeClient()
					{
						@Override
						public void onProgressChanged(WebView view, int newProgress)
						{
							if (haxeObject != null)
								haxeObject.call("onProgressChanged", new Object[]{newProgress});
						}
					});

					((RelativeLayout) mainView).addView(webView, new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

					webView.loadUrl(url);
				}
			});
		}
	}

	public static void openWithData(final String data, final String mimeType, final String encoding)
	{
		if (webView == null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					webView = new WebView(mainActivity);

					webView.getSettings().setJavaScriptEnabled(true);
					webView.getSettings().setDomStorageEnabled(true);
					webView.getSettings().setUseWideViewPort(true);
					webView.getSettings().setLoadWithOverviewMode(true);
					webView.getSettings().setMediaPlaybackRequiresUserGesture(false);
					webView.getSettings().setLoadsImagesAutomatically(true);

					webView.setWebViewClient(new WebViewClient()
					{
						@Override
						public void onPageFinished(WebView view, String url)
						{
							if (haxeObject != null)
								haxeObject.call("onPageFinished", new Object[]{url});
						}

						@Override
						public void onPageStarted(WebView view, String url, android.graphics.Bitmap favicon)
						{
							if (haxeObject != null)
								haxeObject.call("onPageStarted", new Object[]{url});
						}

						@Override
						public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request)
						{
							if (haxeObject != null)
								haxeObject.call("onUrlLoading", new Object[]{ request.getUrl().toString() });

							return super.shouldOverrideUrlLoading(view, request);
						}
					});

					webView.setWebChromeClient(new WebChromeClient()
					{
						@Override
						public void onProgressChanged(WebView view, int newProgress)
						{
							if (haxeObject != null)
								haxeObject.call("onProgressChanged", new Object[]{newProgress});
						}
					});

					((RelativeLayout) mainView).addView(webView, new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

					webView.loadData(data, mimeType, encoding);
				}
			});
		}
	}

	public static void close()
	{
		if (webView != null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				public void run()
				{
					if (webView.getParent() != null)
						((ViewGroup) webView.getParent()).removeView(webView);

					webView.destroy();

					webView = null;
				}
			});
		}
	}

	public static void loadData(final String data, final String mimeType, final String encoding)
	{
		if (webView != null) 
		{
			mainActivity.runOnUiThread(new Runnable() 
			{
				@Override
				public void run() 
				{
					webView.loadData(data, mimeType, encoding);
				}
			});
		}
	}

	public static void loadURL(final String url)
	{
		if (webView != null) 
		{
			mainActivity.runOnUiThread(new Runnable() 
			{
				@Override
				public void run() 
				{
					webView.loadUrl(url);
				}
			});
		}
	}

	public static boolean canGoBack()
	{
		return webView != null && webView.canGoBack();
	}

	public static void goBack()
	{
		if (webView != null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					webView.goBack();
				}
			});
		}
	}

	public static boolean canGoForward()
	{
		return webView != null && webView.canGoForward();
	}

	public static void goForward()
	{
		if (webView != null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					webView.goForward();
				}
			});
		}
	}

	public static void reload()
	{
		if (webView != null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					webView.reload();
				}
			});
		}
	}

	public static void stopLoading()
	{
		if (webView != null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					webView.stopLoading();
				}
			});
		}
	}

	public static void clearCache(final boolean includeDiskFiles)
	{
		if (webView != null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					webView.clearCache(includeDiskFiles);
				}
			});
		}
	}

	public static void clearHistory()
	{
		if (webView != null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					webView.clearHistory();
				}
			});
		}
	}

	public static void clearFormData()
	{
		if (webView != null)
		{
			mainActivity.runOnUiThread(new Runnable()
			{
				@Override
				public void run()
				{
					webView.clearFormData();
				}
			});
		}
	}

	public static void clearCookies()
	{
		mainActivity.runOnUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				CookieManager cookieManager = CookieManager.getInstance();
				cookieManager.removeAllCookies(null);
				cookieManager.flush();
			}
		});
	}

	public void onRestoreInstanceState(Bundle savedState)
	{
		if (webView != null)
			webView.restoreState(savedState);
	}

	public void onSaveInstanceState(Bundle outState)
	{
		if (webView != null)
			webView.saveState(outState);
	}

	public boolean onBackPressed()
	{
		if (webView != null && webView.canGoBack())
		{
			webView.goBack();
			return false;
		}

		return true;
	}
}
