#include "webview_core.hpp"

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

static WKWebView* webView = nil;
static WebViewCallbacks gWebViewCallbacksCopy = {};
static WebViewCallbacks* gWebViewCallbacks = nullptr;

@interface WebViewDelegate : NSObject <WKNavigationDelegate, WKUIDelegate>
@end

@implementation WebViewDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if (gWebViewCallbacks && gWebViewCallbacks->onPageStarted && webView.URL.absoluteString)
    {
		dispatch_async(dispatch_get_main_queue(), ^
		{
			gWebViewCallbacks->onPageStarted(webView.URL.absoluteString.UTF8String);
		});
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (gWebViewCallbacks && gWebViewCallbacks->onPageFinished && webView.URL.absoluteString)
    {
		dispatch_async(dispatch_get_main_queue(), ^
		{
			gWebViewCallbacks->onPageFinished(webView.URL.absoluteString.UTF8String);
		});
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                                decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (gWebViewCallbacks && gWebViewCallbacks->onUrlLoading && navigationAction.request.URL.absoluteString)
    {
		dispatch_async(dispatch_get_main_queue(), ^
		{
			gWebViewCallbacks->onUrlLoading(navigationAction.request.URL.absoluteString.UTF8String);
		});
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

@end

static WebViewDelegate* delegate = nil;

void WebView_Init(const WebViewCallbacks* callbacks)
{
    if (callbacks)
        gWebViewCallbacksCopy = (*callbacks);

    gWebViewCallbacks = &gWebViewCallbacksCopy;

    if (!delegate)
        delegate = [[WebViewDelegate alloc] init];
}

void WebView_OpenWithURL(bool transparent, const char* url)
{
	if (url)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			if (!webView)
			{
				WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
				config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
				config.allowsInlineMediaPlayback = YES;

				webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds] configuration:config];

				if (transparent)
				{
					webView.opaque = NO;
					webView.backgroundColor = [UIColor clearColor];
					webView.scrollView.backgroundColor = [UIColor clearColor];
				}

				webView.scrollView.bounces = NO;

				webView.navigationDelegate = delegate;
				webView.UIDelegate = delegate;

				[[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:webView];
			}

			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:url]]]];

		});
	}
}

void WebView_OpenWithData(bool transparent, const char* data, const char* mimeType, const char* encoding)
{
	if (data)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			if (!webView)
			{
				WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
				config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
				config.allowsInlineMediaPlayback = YES;

				webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds] configuration:config];

				if (transparent)
				{
					webView.opaque = NO;
					webView.backgroundColor = [UIColor clearColor];
					webView.scrollView.backgroundColor = [UIColor clearColor];
				}

				webView.scrollView.bounces = NO;

				webView.navigationDelegate = delegate;
				webView.UIDelegate = delegate;

				[[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:webView];
			}

			[webView loadData:[[NSString stringWithUTF8String:data] dataUsingEncoding:NSUTF8StringEncoding] MIMEType:[NSString stringWithUTF8String:mimeType] characterEncodingName:[NSString stringWithUTF8String:encoding] baseURL:[NSURL URLWithString:@"about:blank"]];
		});
	}
}

bool WebView_IsOpened()
{
	return webView != nil;
}

void WebView_Close()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView removeFromSuperview];
			webView.navigationDelegate = nil;
			webView.UIDelegate = nil;
			webView = nil;
		});
	}
}

void WebView_LoadURL(const char* url)
{
	if (webView && url)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:url]]]];
		});
	}
}

void WebView_LoadData(const char* data, const char* mimeType, const char* encoding)
{
	if (webView && data)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView loadData:[[NSString stringWithUTF8String:data] dataUsingEncoding:NSUTF8StringEncoding] MIMEType:[NSString stringWithUTF8String:mimeType] characterEncodingName:[NSString stringWithUTF8String:encoding] baseURL:[NSURL URLWithString:@"about:blank"]];
		});
	}
}

bool WebView_CanGoBack()
{
    return webView ? [webView canGoBack] : false;
}

void WebView_GoBack()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView goBack];
		});
	}
}

bool WebView_CanGoForward()
{
    return webView ? [webView canGoForward] : false;
}

void WebView_GoForward()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView goForward];
		});
	}
}

void WebView_Reload()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView reload];
		});
	}
}

void WebView_StopLoading()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView stopLoading];
		});
	}
}

void WebView_ClearCache()
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:nil];
	});
}

void WebView_ClearCookies()
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		WKHTTPCookieStore* store = WKWebsiteDataStore.defaultDataStore.httpCookieStore;

		[store getAllCookies:^(NSArray<NSHTTPCookie *> *cookies)
		{
			for (NSHTTPCookie *cookie in cookies)
				[store deleteCookie:cookie completionHandler:nil];
		}];
	});
}
